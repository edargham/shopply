import { Router, Request, Response } from 'express';

import { v4 } from 'uuid';
import { createHash } from 'crypto';

import { 
  authToken, 
  generateAccessTokenAdmin, 
  authenticateToken,
  authorizeSelf, 
  AuthenticatedRequest, 
  escalatePrivilages
} from '../config/auth.config';

import { SysAdminModel } from '../models/sys_admin';

import StatusCodes from '../utils/status_codes';

import { checkValidationResult } from '../validators/validation_result';
import SysAdminsValidator from '../validators/sys_admins';

const COST_SIZE: number = 10;

export const sysAdminRouteName: string = '/api/sysadmins';
const router: Router = Router();

/**
 * @openapi
 * /api/sysadmins/register:
 *  post:
 *    security:
 *      - bearerAuth: []
 *    description: Registers a new system admin for the application and stores their information in the database.
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
 *              lastName:
 *                type: string
 *              email:
 *                type: string
 *              phoneNumber:
 *                type: string
 *              password:
 *                type: string
 *            required:
 *              - username
 *              - firstName
 *              - lastName
 *              - email
 *              - phoneNumber
 *              - password
 *          example:
 *            username: tiesto
 *            firstName: DeeJay
 *            lastName: Tiesto
 *            email: tiesto@test.com
 *            phoneNumber: 81205500
 *            password: Admin@1234
 *    responses:
 *      201:
 *        description: The user was successfuly created.
 *      400:
 *        description: The request failed validation.
 *      500:
 *        description: An internal error occured while creating the user in the database.
 *    tags:
 *      - Sys Admins
 */
router.post(
  '/register',
  authenticateToken,
  escalatePrivilages,
  SysAdminsValidator.validateUserSignup(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const stamp: string = v4();
      const password: string =  createHash('sha512').update(`${ req.body.password }${ stamp }`).digest('hex');
      
      const user: number = await SysAdminModel.count({
        where: {
          username: req.body.username
        }
      });

      if (user > 0) {
        const statusCode: number = StatusCodes.BAD_REQUEST;
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `User with username "${ req.body.username }" already exists.`,
          route: `POST ${ sysAdminRouteName }/register`
        });
      }

      await SysAdminModel.create({
        username: req.body.username,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        phoneNumber: req.body.phoneNumber,
        password: password,
        stamp: stamp,
        dateCreated: new Date()
      }); 

      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly created new system admin.',
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to add the spcified system admin to the database.',
        route: `POST ${ sysAdminRouteName }/register`
      });
    }
  }
);

/**
 * @openapi
 * /api/sysadmins/login:
 *  post:
 *    description: logs in a sys admin and generates a token for their session.
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
 *      400:
 *        description: The request failed validation.
 *      500:
 *        description: An internal error occured authenticating the sys admin.
 *    tags:
 *      - Sys Admins
 */
router.post(
  '/login',
  SysAdminsValidator.validateUserLogin(),
  checkValidationResult,
  async (req: Request, res: Response) => {
    try {
      const statusCode: number = StatusCodes.SUCCESS_CODE;
      const authenticatingUser: SysAdminModel | null = await SysAdminModel.findOne({
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
              token: generateAccessTokenAdmin(authenticatingUser.get(), authToken)
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
        route: `POST ${ sysAdminRouteName }/login`
      });
    } 
  }
);

/**
 * @openapi
 * /api/sysadmins/{username}:
 *  get:
 *    description: Returns the sys admin with the specified username from the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the sys admin that will be returned.
 *    responses:
 *      200:
 *        description: The sys admin was successfuly returned.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The sys admin must be logged in to perform this operation.
 *      403:
 *        description: The sys admin credentials are invalid.
 *      404:
 *        description: The sys admin was not found.
 *      500:
 *        description: An internal error has occured while pulling the specified sys admin from the database.
 *    tags:
 *      - Sys Admins
 */
router.get(
  '/:username',
  authenticateToken,
  escalatePrivilages,
  authorizeSelf,
  SysAdminsValidator.validateGetSingleUser(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    try {
      const requestedUser: SysAdminModel | null = await SysAdminModel.findOne({
        where: {
          username: paramsUsername
        },
        attributes: {
          exclude: [
            'password',
            'stamp'
          ]
        }
      });

      if (!requestedUser) {
        const statusCode: number = StatusCodes.NOT_FOUND;
        
        res.status(statusCode);
        return res.json({
          status: statusCode,
          message: `No sys admin with username ${ paramsUsername } was found.`,
          route: `GET ${ sysAdminRouteName }/${ paramsUsername }`
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
        message: 'Failed to fetch the requested sys admin.',
        route: `GET ${ sysAdminRouteName }/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/sysadmins/{username}:
 *  patch:
 *    description: Updates the sys admin with the specified username in the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the sys admin that will be returned.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              firstName:
 *                type: string
 *              lastName:
 *                type: string
 *            required:
 *              - firstName
 *              - lastName
 *          example:
 *            firstName: DJMC
 *            lastName: Guetta
 *    responses:
 *      200:
 *        description: The sys admin was successfuly updated.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The sys admin must be logged in to perform this operation.
 *      403:
 *        description: The sys admin credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified sys admin from the database.
 *    tags:
 *      - Sys Admins
 */
router.patch(
  '/:username',
  authenticateToken,
  escalatePrivilages,
  authorizeSelf,
  SysAdminsValidator.validateUpdateUser(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    let statusCode: number = StatusCodes.SUCCESS_CODE;

    try {
      const user: SysAdminModel | null = await SysAdminModel.findOne({
        where: {
          username: paramsUsername
        },
        attributes: [
          'username',
          'firstName',
          'lastName'
        ]
      });

      if (user) {
        await user.update({
          firstName: req.body.firstName,
          lastName: req.body.lastName
        });

        res.status(statusCode);
        return res.json({ 
          status: statusCode,
          message: `Succesfuly updated sys admin details.`,
          user: user.get()
        });
      } else {
        throw new Error(`Attempted to modify non-existant sys admin ${ paramsUsername }.`);
      }
    } catch (error) {
      statusCode = StatusCodes.INTERNAL_SERVER_ERROR;
      console.error(error);
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to update user info.',
        route: `PATCH ${ sysAdminRouteName }/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/sysadmins/{username}:
 *  delete:
 *    description: Deletes the sys admin with the specified username from the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the sys admin that will be returned.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              password:
 *                type: string
 *            required:
 *              - password
 *          example:
 *            password: Admin@1234
 *    responses:
 *      200:
 *        description: The sys admin was successfuly deleted.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The sys admin must be logged in to perform this operation.
 *      403:
 *        description: The sys admin credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified sys admin from the database.
 *    tags:
 *      - Sys Admins
 */
router.delete(
  '/:username',
  authenticateToken,
  escalatePrivilages,
  authorizeSelf,
  SysAdminsValidator.validateUserDelete(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    let statusCode: number = StatusCodes.SUCCESS_CODE;

    try {
      const user: SysAdminModel | null = await SysAdminModel.findOne({
        where: {
          username: paramsUsername
        }
      });

      if (user) {
        const password: string = createHash('sha512').update(`${ req.body.password }${ user.get().stamp }`).digest('hex');

        if (password != user.get().password) {
          res.status(statusCode);
          return res.json({
            status: statusCode,
            message: 'Incorrect username or password.'
          });
        }

        await user.destroy();

        res.status(statusCode);
        return res.json({ 
          status: statusCode,
          message: `Succesfuly deleted user.`,
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
        route: `DELETE ${ sysAdminRouteName }/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/sysadmins/change-email/{username}:
 *  patch:
 *    description: Updates the sys admin with the specified username's email in the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the sys admin that will be returned.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              email:
 *                type: string
 *            required:
 *              - email
 *          example:
 *            email: tiesto.dj@test.com
 *    responses:
 *      200:
 *        description: The sys admin was successfuly updated.
 *      400:
 *        description: The request failed validation.
 *      401:
 *        description: The sys admin must be logged in to perform this operation.
 *      403:
 *        description: The sys admin credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified sys admin from the database.
 *    tags:
 *      - Sys Admins
 */
router.patch(
  '/change-email/:username',
  authenticateToken,
  escalatePrivilages,
  authorizeSelf,
  SysAdminsValidator.validateUserChangeEmail(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;

    try {
      const user: SysAdminModel | null = await SysAdminModel.findOne({
        where: {
          username: paramsUsername
        },
        attributes: {
          exclude: [
            'password',
            'stamp'
          ]
        }
      });

      if (user) {
        await user.update({
          email: req.body.email,
        });

        res.status(StatusCodes.SUCCESS_CODE);
        return res.json({ 
          status: StatusCodes.SUCCESS_CODE,
          message: 'Your email was updated successfuly.\nAn email has been sent to you to verify your new email.',
        });
      } else {
        throw new Error(`Attempted to modify non-existant user ${ paramsUsername }.`);
      }
    } catch(error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to update the user email.',
        route: `PATCH ${ sysAdminRouteName }/change-email/${ paramsUsername }`
      });
    }
  }
);

/**
 * @openapi
 * /api/sysadmins/change-password/{username}:
 *  patch:
 *    description: Updates the sys admins with the specified username's password in the database.
 *    security:
 *      - bearerAuth: []
 *    parameters:
 *      - in: path
 *        name: username
 *        schema:
 *          type: string
 *        required: true
 *        description: The username of the sys admins that will be returned.
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              password:
 *                type: string
 *              oldPassword:
 *                type: string
 *            required:
 *              - password
 *              - oldPassword
 *          example:
 *            oldPassword: Admin@1234
 *            password: Admin@4321
 *    responses:
 *      200:
 *        description: The sys admins was successfuly updated.
 *      400:
 *        description: The sys admins failed validation.
 *      401:
 *        description: The sys admins must be logged in to perform this operation.
 *      403:
 *        description: The sys admins credentials are invalid.
 *      500:
 *        description: An internal error has occured while pulling the specified sys admins from the database.
 *    tags:
 *      - Sys Admins
 */
router.patch(
  '/change-password/:username',
  authenticateToken,
  escalatePrivilages,
  authorizeSelf,
  SysAdminsValidator.validateUserChangePassword(),
  checkValidationResult,
  async (req: AuthenticatedRequest, res: Response) => {
    const paramsUsername: string = req.params.username;
    
    const stamp: string = v4();
    
    const password: string =  createHash('sha512').update(`${ req.body.password }${ stamp }`).digest('hex');
    try {
      const user: SysAdminModel | null = await SysAdminModel.findOne({
        where: {
          username: paramsUsername
        },
      });
      
      if (user) {
        const oldPassword: string = req.body.oldPassword;
        const hashedOldPassword: string = createHash('sha512').update(`${ oldPassword }${ user.get().stamp }`).digest('hex');
        if (user.get().password == hashedOldPassword) {
          await user.update({
            password: password,
            stamp: stamp,
          });

          res.status(StatusCodes.SUCCESS_CODE);
          return res.json({ 
            status: StatusCodes.SUCCESS_CODE,
            message: 'Succesfuly updated your password.',
          });
        } else {
          const statusCode : number = StatusCodes.UNAUTHORIZED;
          res.status(statusCode);
          return res.json({
            status: statusCode,
            message: 'Incorrect password.'
          });
        }
      } else {
        throw new Error(`Attempted to modify non-existant user ${ paramsUsername }.`);
      }
    } catch(error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to update the user password.',
        route: `PATCH ${ sysAdminRouteName }/change-password/${ paramsUsername }`
      });
    }
  }
);


// router.patch('/change-phone/:username');


export default router;