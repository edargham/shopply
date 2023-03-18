import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';

export interface IProduct {
  id: string,
  title: string,
  description: string | null,
  imageUrl: string | null,
  price: number,
  stock: number
}

export class ProductModel extends Model<IProduct> {}

ProductModel.init(
  {
    id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true
    },
    imageUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'image_url'
    },
    price: {
      type: DataTypes.DOUBLE,
      allowNull: false
    },
    stock: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'products',
    timestamps: false
  }
);