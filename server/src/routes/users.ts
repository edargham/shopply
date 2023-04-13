import { Router, Request, Response } from 'express';
import multer, { Multer, StorageEngine, FileFilterCallback } from 'multer';
import { Model } from 'sequelize';
import { v4 } from 'uuid';
import { mkdirSync, existsSync, removeSync } from 'fs-extra';
import { createHash } from 'crypto';


import { physicalRootDir } from '../config/server.config';
import { DestinationCallback, FileNameCallback, limits } from '../config/multer.config';
import { 
  authToken, 
  generateAccessToken, 
  authenticateToken,
  authorizeSelf, 
  AuthenticatedRequest 
} from '../config/auth.config';

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
 *    description: Signs up a new user for the application and stores their information in the database.
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
 *        description: The user was successfuly created.
 *      400:
 *        description: The request failed validation.
 *      500:
 *        description: An internal error occured while creating the user in the database.
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
      const password: string =  createHash('sha512').update(`${ req.body.password }${ stamp }`).digest('hex');
      
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

/**
 * @openapi
 * /api/users/login:
 *  post:
 *    description: logs in a user and generates a token for their session.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              username:
 *                type: string
 *              password:
 *                type: string
 *            required:
 *              - username
 *              - password
 *          example:
 *            username: tiesto
 *            password: Admin@1234
 *    responses:
 *      200:
 *        description: The authentication process completed.
 *      500:
 *        description: An internal error occured authenticating the user.
 *    tags:
 *      - Users
 */
router.post(
  '/login',
  async (req: Request, res: Response) => {
    try {
      const statusCode: number = StatusCodes.SUCCESS_CODE;
      const authenticatingUser: UserModel | null = await UserModel.findOne({
        where: {
          username: req.body.username
        }
      });

      if (authenticatingUser) {
        const password: string = createHash('sha512').update(`${ req.body.password }${ authenticatingUser.get().stamp }`).digest('hex');
        if (password == authenticatingUser.get().password) {
          res.status(statusCode);
          return res.json({
              status: 200,
              token: generateAccessToken(authenticatingUser.get(), authToken)
          });
        } else {
          res.status(statusCode);
          return res.json({
            status: statusCode,
            message: 'Incorrect username or password.'
          });
        }
      } else {
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: 'Incorrect username or password.'
        });
      }
    } catch (error) {
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      console.error(error);
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to authenticate user due to a server error. Please try again later.',
        route: `POST ${ usersRouteName }/login`
      });
    } 
  }
);

/**
 * @openapi
 * /api/users/{username}:
 *  get:
 *    description: Returns the user with the specified username from the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the user that will be returned.
 *    responses:
 *      200:
 *        description: The user was successfuly returned.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      404:
 *        description: The user was not found.
 *      500:
 *        description: An internal error has occured while pulling the specified user from the database.
 *    tags:
 *      - Users
 */
router.get(
  '/:username',
  authenticateToken,
  authorizeSelf,
  UsersValidator.validateGetSingleUser(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    try {
      const requestedUser: UserModel | null = await UserModel.findOne({
        where: {
          username: paramsUsername
        },
        attributes: [
          'username',
          'first_name',
          'middle_name',
          'last_name',
          'date_of_birth',
          'sex',
          'email',
          'phone_number',
          'date_joined',
          'profile_photo_url',
          'is_verified'
        ]
      });

      if (!requestedUser) {
        const statusCode: number = StatusCodes.NOT_FOUND;
        
        res.status(statusCode);
        return res.json({
          status: statusCode,
          msg: `No user with username ${ paramsUsername } was found.`,
          route: `GET ${ usersRouteName }/${ paramsUsername }`
        });
      }

      res.status(StatusCodes.SUCCESS_CODE);

      return res.json(requestedUser);
    } catch (error) {
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      console.error(error);
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to fetch the requested user.',
        route: `GET ${ usersRouteName }/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/users/{username}:
 *  patch:
 *    description: Updates the user with the specified username from the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the user that will be returned.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              firstName:
 *                type: string
 *              middleName:
 *                type: string
 *              lastName:
 *                type: string
 *            required:
 *              - firstName
 *              - middleName
 *              - lastName
 *          example:
 *            firstName: DJMC
 *            middleName: Vergicon
 *            lastName: Guetta
 *    responses:
 *      200:
 *        description: The user was successfuly updated.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified user from the database.
 *    tags:
 *      - Users
 */
router.patch(
  '/:username',
  authenticateToken,
  authorizeSelf,
  UsersValidator.validateUpdateUser(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    let statusCode: number = StatusCodes.SUCCESS_CODE;

    try {
      const user: UserModel | null = await UserModel.findOne({
        where: {
          username: paramsUsername
        },
        attributes: [
          'username',
          'first_name',
          'middle_name',
          'last_name'
        ]
      });

      if (user) {
        await user.update({
          firstName: req.body.firstName,
          middleName: req.body.middleName,
          lastName: req.body.lastName
        });

        res.status(statusCode);
        return res.json({ 
          status: statusCode,
          msg: `Succesfuly updated user details.`,
          user: user.get()
        });
      } else {
        throw new Error(`Attempted to modify non-existant user ${ paramsUsername }.`);
      }
    } catch (error) {
      statusCode = StatusCodes.INTERNAL_SERVER_ERROR;
      console.error(error);
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to update user info.',
        route: `PATCH ${ usersRouteName }/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/users/{username}:
 *  delete:
 *    description: Deletes the user with the specified username from the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the user that will be returned.
 *    responses:
 *      200:
 *        description: The user was successfuly deleted.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The user must be logged in to perform this operation.
 *      403:
 *        description: The user credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified user from the database.
 *    tags:
 *      - Users
 */
router.delete(
  '/:username',
  authenticateToken,
  authorizeSelf,
  UsersValidator.validateGetSingleUser(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    let statusCode: number = StatusCodes.SUCCESS_CODE;

    try {
      const user: UserModel | null = await UserModel.findOne({
        where: {
          username: paramsUsername
        }
      });

      if (user) {
        await user.destroy();

        res.status(statusCode);
        return res.json({ 
          status: statusCode,
          msg: `Succesfuly deleted user.`,
          user: user.get()
        });
      } else {
        throw new Error(`Attempted to modify non-existant user ${ paramsUsername }.`);
      }
    } catch (error) {
      statusCode = StatusCodes.INTERNAL_SERVER_ERROR;
      console.error(error);
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to delete user.',
        route: `DELETE ${ usersRouteName }/${ paramsUsername }`
      });
    }
  }
);


router.patch('/change-photo/:username');


router.patch('/change-email/:username');


router.patch('/change-password/:username');


router.patch('/change-phone/:username');


export default router;