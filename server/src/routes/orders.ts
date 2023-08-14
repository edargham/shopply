import { Router, Request, Response } from 'express';
import { Model, Transaction } from 'sequelize';
import { v4 } from 'uuid';

import db from '../config/database.config';

import { OrderModel, OrderStatus, IOrder } from '../models/order';
import { 
  CartItemModel, 
  ICartItem, 
  VwCartItemModel,
  IVwCartItem
} from '../models/cart_item';

import OrderViewModel from '../models/view_models/order_view';
import { ProductModel } from '../models/product';

import { authenticateToken, AuthenticatedRequest, authorizeSelf, escalatePrivilages } from '../config/auth.config';

import StatusCodes from '../utils/status_codes';

import OrdersValidator from '../validators/orders';
import { checkValidationResult } from '../validators/validation_result';

export const ordersRouteName: string = '/api/orders';
const router: Router = Router();

const buildOrderResponse = async (orders: OrderModel[]): Promise<OrderViewModel[]> => {
  let orderViews: OrderViewModel[] = [];
  for (let i: number = 0; i < orders.length; i++) {
    const cartItems: VwCartItemModel[] = await VwCartItemModel.findAll({
      where: {
        orderId: orders[i].get().id
      }
    });

    let items: IVwCartItem[] = [];
    for (let j: number = 0; j < cartItems.length; j++) {
      items.push({
        id: cartItems[j].get().id,
        orderId: cartItems[j].get().orderId,
        productId: cartItems[j].get().productId,
        price: cartItems[j].get().price,
        quantity: cartItems[j].get().quantity,
        username: cartItems[j].get().username,
        title: cartItems[j].get().title,
      });
    }

    orderViews.push(
      new OrderViewModel(
        orders[i].get().id,
        orders[i].get().amountPaid,
        orders[i].get().dateOrdered,
        orders[i].get().username,
        orders[i].get().statusId,
        items
      )
    );
  }
  return orderViews;
}

router.get(
  '/',
  authenticateToken,
  escalatePrivilages,
  OrdersValidator.validateGetQuery(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      let orders: OrderModel[] | OrderViewModel[];
      if (req.query.status) {
        const qStatus = req.query.status as string;
        const pStatus: number | null = Number.parseInt(qStatus);

        orders = await OrderModel.findAll({
          where: {
            statusId: pStatus
          },
          order: [
            ['status_id', 'DESC']
          ]
        });

        if (orders.length > 0) {
          orders = await buildOrderResponse(orders);
        }
      } else {
        orders = await OrderModel.findAll(
          {
            order: [
              ['status_id', 'DESC']
            ]
          }
        );

        if (orders.length > 0) {
          orders = await buildOrderResponse(orders);
        }
      }

      res.status(StatusCodes.SUCCESS_CODE);
      return res.json({
        status: StatusCodes.SUCCESS_CODE,
        orders: orders
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to read orders from the database.',
        route: `GET ${ ordersRouteName }/`
      });
    }
  }
);

router.get(
  '/:username',
  authenticateToken,
  authorizeSelf,
  OrdersValidator.validateGetByUsernameQuery(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const username: string = req.params.username;
      let orders: OrderModel[] | OrderViewModel[];

      if (req.query.status) {
        const qStatus: string = req.query.status as string;
        const pStatus: number | null = Number.parseInt(qStatus);
        
        orders = await OrderModel.findAll({
          where: {
            statusId: pStatus,
            username: username
          },
          order: [
            ['status_id', 'DESC']
          ]
        });
        
        if (orders.length > 0) {
          orders = await buildOrderResponse(orders);
        }
      } else {
        orders = await OrderModel.findAll({
          where: {
            username: username
          },
          order: [
            ['status_id', 'DESC']
          ]
        });

        if (orders.length > 0) {
          orders = await buildOrderResponse(orders);
        }        
      }

      res.status(StatusCodes.SUCCESS_CODE);
      return res.json({
        status: StatusCodes.SUCCESS_CODE,
        orders: orders
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to read orders from the database.',
        route: `GET ${ ordersRouteName }/`
      });
    }
  }
);

// TODO - Update order status.
router.patch(
  '/update-status/:orderId',
  authenticateToken,
  escalatePrivilages,
  async (req: Request, res: Response) => {
    const orderId: string = req.params.orderId;
    
    try {
      let transaction = await db.transaction();
      const statusUpdate: OrderStatus = req.body.orderStatus;

      let order: OrderModel | null = await OrderModel.findOne({
        where: {
          id: orderId
        }
      });

      if (order) {
        switch (statusUpdate) {
          case OrderStatus.Processing:
            let cartItems: VwCartItemModel[] | null = await VwCartItemModel.findAll({
              where: {
                id: orderId
              }
            });

            if (cartItems) {
              for (const cartItem of cartItems) {
                const product: ProductModel | null = await ProductModel.findOne({
                  where: {
                    id: cartItem.get().productId
                  }
                });

                if (product) {
                  const newStock: number = product.get().stock - cartItem.get().quantity
                }
              }
            }
          break;
          case OrderStatus.Delivering:
          break;
          case OrderStatus.Completed:
          break;
          default:
          break;
        }
      } else {

      }
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to update order status.',
        route: `PATCH ${ ordersRouteName }/update-status/${ orderId }`
      });
    }
  }
);

router.post(
  '/',
  authenticateToken,
  OrdersValidator.validateSubmitOrder(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    let transaction: Transaction = await db.transaction();
    try {
      const orderId: string = v4();
      const rec: Model<IOrder> = await OrderModel.create({
        id: orderId,
        amountPaid: req.body.amountPaid,
        dateOrdered: new Date(),
        statusId: OrderStatus.Pending as number,
        username: req.user!.username
      }, { transaction: transaction }); 

      const cartItems: IVwCartItem[] = req.body.cartItems;

      for (let i: number = 0; i < cartItems.length; i++) {
        const cartItemId: string = v4();

        await CartItemModel.create({
          id: cartItemId,
          price: cartItems[i].price,
          productId: cartItems[i].productId,
          quantity: cartItems[i].quantity,
          username: req.user!.username,
          orderId: orderId,
        }, { transaction: transaction });

        cartItems[i].id = cartItemId;
      }
      
      const order: OrderViewModel = new OrderViewModel(
        rec.get().id,
        rec.get().amountPaid,
        rec.get().dateOrdered,
        rec.get().username,
        rec.get().statusId,
        cartItems
      );
        
      await transaction.commit();

      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly submitted new order.',
        order: order
      });
    } catch (error) {
      await transaction.rollback();
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to submit the specified order to the database.',
        route: `POST ${ ordersRouteName }/`
      });
    }
  }
);

export default router;