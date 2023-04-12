import { Express, Request, Response } from 'express';
import swaggerJSDoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const swaggerOptions: swaggerJSDoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Shopply REST API Docs',
      version: '0.1.0'
    },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'Use the token you generated with the login route.'
        }
      }
    }
  },
  apis: [
    './src/routes/products.ts',
    './src/routes/users.ts'
  ]
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

const swaggerDocs = (app: Express, port: number) => {
  app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
  app.get('docs.json', (req: Request, res: Response) => {
    res.setHeader('Content-Type', 'application/json');
    res.send(swaggerSpec);
  }); 

  console.log(`Docs available at http://localhost:${port}/docs`);
}

export default swaggerDocs;