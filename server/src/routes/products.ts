import { Router, Request, Response } from 'express';
import multer, { Multer, StorageEngine, FileFilterCallback } from 'multer';
import { Model } from 'sequelize';
import { v4 } from 'uuid';
import { mkdirSync, existsSync, removeSync } from 'fs-extra';

import { ProductModel, IProduct } from '../models/product';

import { physicalRootDir } from '../config/server.config';
import { authenticateToken, AuthenticatedRequest } from '../config/auth.config';
import { DestinationCallback, FileNameCallback, limits } from '../config/multer.config';

import StatusCodes from '../utils/status_codes';

import ProductValidator from '../validators/products';
import { checkValidationResult } from '../validators/validation_result';

export const productsRouteName: string = '/api/products';
const router: Router = Router();

const storageStrat: StorageEngine = multer.diskStorage({
  destination: (req: Request, file: Express.Multer.File, next: DestinationCallback) => {
    const uploadPath: string = `${ physicalRootDir }uploads/products`;

    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath, { recursive: true });
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
      return res.json({
        status: StatusCodes.SUCCESS_CODE,
        products: products
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to read products from the database.',
        route: `GET ${ productsRouteName }/`
      });
    }
  }
);

// TODO - Get product details with favorite info.

/**
 * @openapi
 * /api/products/{id}:
 *  get:
 *    description: Returns the product with the specified ID from the database.
 *    parameters:
 *      - in: path
 *        name: id
 *        schema:
 *          type: string
 *        required: true
 *        description: The ID of the product that will be returned.
 *    responses:
 *      200:
 *        description: The product was successfuly returned.
 *      400:
 *        description: The request failed validation.
 *      404:
 *        description: The product was not found.
 *      500:
 *        description: An internal error has occured while pulling the specified product from the database.
 *    tags:
 *      - Products
 */
router.get(
  '/:id',
  ProductValidator.validateGetSingleProduct(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const paramId: string = req.params.id;
      const product: ProductModel | null = await ProductModel.findOne({
        where: {
          id: paramId
        }
      });

      if (!product) {
        const statusCode: number = StatusCodes.NOT_FOUND;
        
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `No product with id ${ paramId } was found.`,
          route: `GET ${ productsRouteName }/${ paramId }`
        });
      }

      res.status(StatusCodes.SUCCESS_CODE);
      return res.json(product);
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to read products from the database.',
        route: `GET ${ productsRouteName }/`
      });
    }
  }
);

/**
 * @openapi
 * /api/products:
 *  post:
 *    security:
 *      - bearerAuth: []
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
 *                type: number
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
 *        description: The product was successfuly created.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      500:
 *        description: An internal error occured while creating the product in the database.
 *    tags:
 *      - Products
 */
router.post(
  '/',
  authenticateToken,
  uploads.single('image'),
  ProductValidator.validateCreateProduct(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
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
        message: 'Failed to add the spcified product to the database.',
        route: `POST ${ productsRouteName }/`
      });
    }
  }
);

/**
 * @openapi
 * /api/products/{id}:
 *  patch:
 *    security:
 *      - bearerAuth: []
 *    description: Updates the selected product in the database.
 *    parameters:
 *      - in: path
 *        name: id
 *        schema:
 *          type: string
 *        required: true
 *        description: The ID of the product to update.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              description:
 *                type: string
 *              price:
 *                type: number
 *              stock:
 *                type: integer
 *            required:
 *              - price
 *              - stock
 *          example:
 *            description: This is a test product for the shopply API, currently unavailable.
 *            price: 14.99
 *            stock: 150
 *    responses:
 *      200:
 *        description: The product was successfuly updated.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      404:
 *        description: The selected product was not found.
 *      500:
 *        description: An internal error occured while updating the product in the database.
 *    tags:
 *      - Products
 */
router.patch(
  '/:id',
  authenticateToken,
  ProductValidator.validateUpdateProduct(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const productId: string = req.params.id;
    try {
      const product: ProductModel | null = await ProductModel.findOne({
        where: {
          id: productId
        }
      });

      if (product) {
        await product.update({
          description: req.body.description,
          price: req.body.price,
          stock: req.body.stock
        });

        return res.json({ 
          status: StatusCodes.SUCCESS_CODE,
          message: `Succesfuly updated product with id ${ req.params.id }.`,
          product: product.get()
        });
      } else {
        const statusCode: number = StatusCodes.NOT_FOUND;
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `No product with id ${ req.params.id } was found in the database.`,
          route: `PATCH ${ productsRouteName }/${ productId }`
        });
      }
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: `Failed to update product with id ${ req.params.id } in the database.`,
        route: `PATCH ${ productsRouteName }/${ productId }`
      });
    }
  }
);

/**
 * @openapi
 * /api/products/{id}:
 *  delete:
 *    security:
 *      - bearerAuth: []
 *    description: Removes the specified product's reference from the database.
 *    parameters:
 *      - in: path
 *        name: id
 *        schema:
 *          type: string
 *        required: true
 *        description: The ID of the product that will be deleted.
 *    responses:
 *      200:
 *        description: The product was successfuly deleted.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      404:
 *        description: The selected product was not found.
 *      500:
 *        description: An internal error occured while removing the product from the database.
 *    tags:
 *      - Products
 */
router.delete(
  '/:id',
  authenticateToken,
  ProductValidator.validateDelete(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const productId: string = req.params.id;
    let statusCode: number = StatusCodes.SUCCESS_CODE;
    try {
      // TODO - cascade delete all the product references in other tables.
      const product: ProductModel | null = await ProductModel.findOne({
        where: {
          id: productId
        }
      });

      if (product) {
        await product.destroy();

        const imagePath: string = `${ physicalRootDir }${ product.get().imageUrl }`;
        removeSync(imagePath);        

        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `Succesfuly deleted product with id ${ productId }.`,
          product: product.get()
        });
      } else {
        statusCode = StatusCodes.NOT_FOUND;
        
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `No product with id ${ req.params.id } was found.`,
          route: `DELETE ${ productsRouteName }/${ productId }`
        });
      }
    } catch (error) {
      console.error(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR);
      return res.json({
        status: statusCode,
        message: `Failed to delete the specified product with id: ${ productId } from the database.`,
        route: `DELETE ${ productsRouteName }/${ productId }`
      });
    }
  }
);

/**
 * @openapi
 * /api/products/update-photo/{id}:
 *  patch:
 *    security:
 *      - bearerAuth: []
 *    description: Updates the specified product's thumbnail in the database.
 *    parameters:
 *      - in: path
 *        name: id
 *        schema:
 *          type: string
 *        required: true
 *        description: The ID of the product that will have its thumbnail updated.
 *    requestBody:
 *      required: true
 *      content:
 *        multipart/form-data:
 *          schema:
 *            type: object
 *            properties:
 *              image:
 *                type: string
 *                format: base64
 *            required:
 *              - image
 *    responses:
 *      200:
 *        description: The product was successfuly updated.
 *      400:
 *        description: The request failed validation, or the image failed to uplaod.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      404:
 *        description: The selected product was not found.
 *      500:
 *        description: An internal error occured while updating the product in the database.
 *    tags:
 *      - Products
*/
router.patch(
  '/update-photo/:id',
  authenticateToken,
  uploads.single('image'),
  ProductValidator.validateUpdateImage(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const productId: string = req.params.id;
    try {
      if(req.file) {
        const product: ProductModel | null = await ProductModel.findOne({
          where: {
            id: productId
          }
        });
        
        if (product) {
          const oldImagePath: string = `${ physicalRootDir }${ product.get().imageUrl }`;
          
          await product.update({
            imageUrl: req.file.path.replaceAll('\\', '/').replace('dist/', ''),
          });
          
          removeSync(oldImagePath);
          
          return res.json({ 
            status: StatusCodes.SUCCESS_CODE,
            message: `Succesfuly updated product's thumbnail with id ${ req.params.id }.`,
            product: product.get()
          });
        } else {
          const statusCode: number = StatusCodes.NOT_FOUND;
          res.status(statusCode);
          return res.json({
            status: statusCode,
            message: `No product with id ${ req.params.id } was found.`,
            route: `PATCH ${ productsRouteName }/update-photo/${ productId }`
          });
        }
      } else {
        const statusCode: number = StatusCodes.BAD_REQUEST;
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: 'Failed to upload the selected image to the database.',
          route: `PATCH ${ productsRouteName }/update-photo/${ productId }`
        });
      }
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to upload the selected image to the database.',
        route: `PATCH ${ productsRouteName }/update-photo/${ productId }`
      });
    }
  }
);

export default router;