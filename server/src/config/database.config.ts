import { Sequelize } from 'sequelize';

const dbConnectionConfiguration: Sequelize = new Sequelize(
  'shopply',
  'postgres',
  'anrc1998;',
  {
    host: 'localhost',
    dialect: 'postgres'
  }
);

export default dbConnectionConfiguration;
