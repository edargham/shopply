import { Router, Request, Response } from 'express';
import { Model } from 'sequelize';
import { v4 } from 'uuid';

import { ProductModel, IProduct } from '../models/product';

import StatusCodes from '../utils/status_codes';

import ProductValidator from '../validators/products';
import { checkValidationResult } from '../validators/validation_result';

const router: Router = Router();

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
 *        application/json:
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
  ProductValidator.validateCreateProduct(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const rec: Model<IProduct> = await ProductModel.create({
        id: v4(),
        title: req.body.title,
        description: req.body.description,
        imageUrl: null,
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