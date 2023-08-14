import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';

export interface IOrder {
  id: string,
  amountPaid: number,
  dateOrdered: Date,
  username: string,
  statusId: number,
}

export enum OrderStatus {
  Pending    = 1,
  Processing = 2,
  Delivering = 3,
  Completed  = 4,
  Canceled   = 5
}

export class OrderModel extends Model<IOrder> {}

OrderModel.init(
  {
    id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
    },
    amountPaid: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'amount_paid'
    },
    dateOrdered: {
      type: DataTypes.DATE,
      allowNull: false,
      field: 'date_ordered'
    },
    username: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    statusId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'status_id'
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'order',
    timestamps: false
  }
);