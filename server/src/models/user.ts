import { Model, DataTypes } from 'sequelize';
import dbConnectionConfiguration from '../config/database.config';
import { v4 } from 'uuid';

export interface IUser {
  username: string,
  firstName: string,
  middleName: string,
  lastName: string,
  dateOfBirth: Date,
  sex: boolean,
  email: string,
  phoneNumber: string | null,
  password: string,
  stamp: string,
  dateJoined: Date,
  profilePhotoUrl: string | null,
  isVerified: boolean,
  verificationHash: string
}

export class UserModel extends Model<IUser> {}

UserModel.init(
  {
    username: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false
    },
    firstName: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'first_name'
    },
    middleName: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'middle_name'
    },
    lastName: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'last_name'
    },
    dateOfBirth: {
      type: DataTypes.DATEONLY,
      allowNull: false,
      field: 'date_of_birth'
    },
    sex: {
      type: DataTypes.BOOLEAN,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false
    },
    phoneNumber: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'phone_number'
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false
    },
    stamp: {
      type: DataTypes.STRING,
      allowNull: false
    },
    dateJoined: {
      type: DataTypes.DATE,
      allowNull: false,
      field: 'date_joined'
    },
    profilePhotoUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'profile_photo_url'
    },
    isVerified: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
      field: 'is_verified'
    },
    verificationHash: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: v4(),
      field: 'verification_hash'
    }
  },
  {
    sequelize: dbConnectionConfiguration,
    schema: 'shopply',
    tableName: 'user',
    timestamps: false
  }
);
