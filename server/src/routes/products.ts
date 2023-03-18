import { Router, Request, Response } from 'express';
import multer, { Multer, StorageEngine, FileFilterCallback } from 'multer';
import { Model } from 'sequelize';
import { v4 } from 'uuid';
import { mkdirSync, existsSync } from 'fs-extra';

import { ProductModel, IProduct } from '../models/product';

import { DestinationCallback, FileNameCallback, limits } from '../config/multer.config';

import StatusCodes from '../utils/status_codes';

import ProductValidator from '../validators/products';
import { checkValidationResult } from '../validators/validation_result';

const router: Router = Router();

const storageStrat: StorageEngine = multer.diskStorage({
  destination: (req: Request, file: Express.Multer.File, next: DestinationCallback) => {
    const uploadPath: string = './dist/uploads';

    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath);
    }
    
    next(null, uploadPath);
  },
  filename: (req: Request, file: Express.Multer.File, next: FileNameCallback) => {
    next(null, `product_${ v4() }_${file.originalname}`);
  }
});

const fileTypeFilterStrat = (req: Request, file: Express.Multer.File, next: FileFilterCallback) => {
  if (limits.allowedFiles.includes(file.mimetype)) {
    next(null, true);
  } else {
    next(null, false);
  }
}

const uploads: Multer = multer({
  storage: storageStrat, 
  limits: {
    fileSize: 1024*1024 * limits.maxFileSizeMB,
    fieldNameSize: 64
  },
  fileFilter: fileTypeFilterStrat
});

export const productsRouteName: string = '/api/products';

/**
 * @openapi
 * /api/products:
 *  get:
 *    description: Returns a list of all the products from the database.
 *    responses:
 *      200:
 *        description: All products were successfuly returned.
 *      500:
 *        description: An internal error has occured while pulling the list of products from the database.
 *    tags:
 *      - Products
 */
router.get(
  '/',
  async (req: Request, res: Response) => {
    try {
      const products: ProductModel[] = await ProductModel.findAll();
      res.status(StatusCodes.SUCCESS_CODE);
      return res.json(products);
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        msg: 'Failed to read products from the database.',
        route: `GET ${ productsRouteName }/`
      });
    }
  }
);

/**
 * @openapi
 * /api/products:
 *  post:
 *    description: Inserts a new product into the database.
 *    requestBody:
 *      required: true
 *      content:
 *        multipart/form-data:
 *          schema:
 *            type: object
 *            properties:
 *              title:
 *                type: string
 *              description:
 *                type: string
 *              price:
 *                type: double
 *              stock:
 *                type: integer
 *              image:
 *                type: string
 *                format: base64
 *            required:
 *              - title
 *              - price
 *              - stock
 *          example:
 *            title: Test
 *            description: This is a test product for the shopply API, currently unavailable.
 *            price: 9.99
 *            stock: 100
 *    responses:
 *      201:
 *        description: The offer was successfuly created.
 *      400:
 *        description: The request failed validation.
 *      500:
 *        description: An internal error occured while creating the offer in the database.
 *    tags:
 *      - Products
 */
router.post(
  '/',
  uploads.single('image'),
  ProductValidator.validateCreateProduct(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const rec: Model<IProduct> = await ProductModel.create({
        id: v4(),
        title: req.body.title,
        description: req.body.description,
        imageUrl: req.file?.path.replace('dist/', ''),
        price: req.body.price,
        stock: req.body.stock
      }); 

      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly created new product.',
        product: rec
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        msg: 'Failed to add the spcified product to the database.',
        route: `GET ${ productsRouteName }/`
      });
    }
  }
);

export default router;