import { Router, Request, Response } from 'express';
import multer, { Multer, StorageEngine, FileFilterCallback } from 'multer';
import { Model } from 'sequelize';
import { v4 } from 'uuid';
import { mkdirSync, existsSync, removeSync } from 'fs-extra';
import { hash } from 'bcrypt';


import { physicalRootDir } from '../config/server.config';
import { DestinationCallback, FileNameCallback, limits } from '../config/multer.config';

import { UserModel, IUser } from '../models/user';

import StatusCodes from '../utils/status_codes';

import { checkValidationResult } from '../validators/validation_result';
import UsersValidator from '../validators/users';

const COST_SIZE: number = 10;

export const usersRouteName: string = '/api/users';
const router: Router = Router();

const storageStrat: StorageEngine = multer.diskStorage({
  destination: (req: Request, file: Express.Multer.File, next: DestinationCallback) => {
    const uploadPath: string = `${ physicalRootDir }uploads`;

    if (!existsSync(uploadPath)) {
      mkdirSync(uploadPath);
    }
    
    next(null, uploadPath);
  },
  filename: (req: Request, file: Express.Multer.File, next: FileNameCallback) => {
    next(null, `product_${ v4() }_${file.originalname}`);
  }
});

const fileTypeFilterStrat = (req: Request, file: Express.Multer.File, next: FileFilterCallback) => {
  if (limits.allowedFiles.includes(file.mimetype)) {
    next(null, true);
  } else {
    next(null, false);
  }
}

const uploads: Multer = multer({
  storage: storageStrat, 
  limits: {
    fileSize: 1024*1024 * limits.maxFileSizeMB,
    fieldNameSize: 64
  },
  fileFilter: fileTypeFilterStrat
});

/**
 * @openapi
 * /api/users/signup:
 *  post:
 *    description: Signs up a new user for the application and stores their inf in the database.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              username:
 *                type: string
 *              firstName:
 *                type: string
 *              middleName:
 *                type: string
 *              lastName:
 *                type: string
 *              dateOfBirth:
 *                type: date
 *              sex:
 *                type: boolean
 *              email:
 *                type: string
 *              phoneNumber:
 *                type: string
 *              password:
 *                type: string
 *            required:
 *              - username
 *              - firstName
 *              - middleName
 *              - lastName
 *              - dateOfBirth
 *              - sex
 *              - email
 *              - password
 *          example:
 *            username: tiesto
 *            firstName: DeeJay
 *            middleName: Avigilon
 *            lastName: Tiesto
 *            dateOfBirth: 1998-09-11T20:19:25Z
 *            sex: true
 *            email: tiesto@test.com
 *            password: Admin@1234
 *    responses:
 *      201:
 *        description: The product was successfuly created.
 *      400:
 *        description: The request failed validation.
 *      500:
 *        description: An internal error occured while creating the product in the database.
 *    tags:
 *      - Users
 */
router.post(
  '/signup',
  UsersValidator.validateUserSignup(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const stamp: string = v4();
      const password: string = await hash(`${ req.body.password }${ stamp }`, COST_SIZE);
      
      const rec: Model<IUser> = await UserModel.create({
        username: req.body.username,
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        dateOfBirth: req.body.dateOfBirth,
        sex: req.body.sex,
        email: req.body.email,
        phoneNumber: req.body.phoneNumber,
        password: password,
        stamp: stamp,
        dateJoined: new Date(),
        profilePhotoUrl: null,
        isVerified: false,
        verificationHash: v4()
      }); 

      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly created new user.',
        product: rec
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        msg: 'Failed to add the spcified user to the database.',
        route: `POST ${ usersRouteName }/signup`
      });
    }
  }
);


router.post(
  '/login',
  async (req: Request, res: Response) => {
    try {
      
    } catch (error) {

    } 
  }
);


router.get('/:username');


router.patch('/:username');


router.delete('/:username');


router.patch('/change-photo/:username');


router.patch('/change-email/:username');


router.patch('/change-password/:username');


router.patch('/change-phone/:username');


export default router;