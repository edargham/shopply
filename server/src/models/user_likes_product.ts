import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';
import { v4 } from 'uuid';

export interface IUserLikesProducts {
  id: string,
  username: string,
  productId: string
}

export class UserLikesModel extends Model<IUserLikesProducts> {}

UserLikesModel.init(
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
      field: 'product_id'
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'user_likes_products',
    timestamps: false,
  }
);