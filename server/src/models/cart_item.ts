import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';

export interface ICartItem {
  id: string | null,
  username: string,
  productId: string,
  quantity: string,
  price: number,
  orderId: string | null,
}

export interface IVwCartItem {
  id: string | null,
  username: string,
  productId: string,
  quantity: string,
  price: number,
  orderId: string | null,
  title: string | null
}

export class CartItemModel extends Model<ICartItem> {}
export class VwCartItemModel extends Model<IVwCartItem> {}

CartItemModel.init(
  {
    id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    productId: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'product_id',
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    price: {
      type: DataTypes.DOUBLE,
      allowNull: false,
    },
    orderId: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'order_id'
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'cart_item',
    timestamps: false
  }
)

VwCartItemModel.init(
  {
    id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    productId: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'product_id',
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    price: {
      type: DataTypes.DOUBLE,
      allowNull: false,
    },
    orderId: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'order_id'
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'vw_cart_item',
    timestamps: false
  }
)
