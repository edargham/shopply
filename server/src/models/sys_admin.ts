import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';

export interface ISysAdmin {
  username: string,
  firstName: string,
  lastName: string,
  email: string,
  phoneNumber: string | null,
  password: string,
  stamp: string,
  dateCreated: Date,
}

export class SysAdminModel extends Model<ISysAdmin> {}

SysAdminModel.init(
  {
    username: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
      unique: true
    },
    firstName: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'first_name'
    },
    lastName: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'last_name'
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    phoneNumber: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'phone_number',
      unique: true
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false
    },
    stamp: {
      type: DataTypes.STRING,
      allowNull: false
    },
    dateCreated: {
      type: DataTypes.DATE,
      allowNull: false,
      field: 'date_created'
    },
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'sys_admin',
    timestamps: false,
  }
);