import express, { Express } from 'express';

import dbConnectionConfiguration from './config/database.config';
import swaggerDocs from './config/swagger.config';

import productRoutes, { productsRouteName } from './routes/products';

const app: Express = express();
const port: number = 3000;

try {
  dbConnectionConfiguration.authenticate();
  console.log('Connection has been established successfully.');
} catch (error) {
  console.error('Unable to connect to the database: ', error);
}

// Middleware
app.use(express.json());
app.use('/uploads', express.static('./dist/uploads'))

// Register Routes
app.use(productsRouteName, productRoutes);

// Listen for requests.
app.listen(port, () => {
  console.log(`API serivce started successfuly and is listening for requests on port ${ port }.`);
  swaggerDocs(app, port);
});