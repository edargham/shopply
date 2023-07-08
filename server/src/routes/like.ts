import { Router, Request, Response } from 'express';
import { v4 } from 'uuid';
import { 
  authToken, 
  generateAccessToken, 
  authenticateToken,
  authorizeSelf, 
  AuthenticatedRequest 
} from '../config/auth.config';

import { UserLikesModel } from '../models/user_likes_product';

import StatusCodes from '../utils/status_codes';

import { checkValidationResult } from '../validators/validation_result';

export const likeRouteName: string = '/api/like';
const router: Router = Router();

router.post(
  '/',
  authenticateToken,
  async (req: AuthenticatedRequest, res: Response) => { 
    try {
      await UserLikesModel.create({
        id: v4(),
        username: req.user!.username,
        productId: req.body.productId,
      });
      // TODO - Get Liked Product View Model.
      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly liked product.'
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to submit the specified order to the database.',
        route: `POST ${ likeRouteName }/`
      });
    }
  }
);

router.delete(
  '/',
  authenticateToken,
  async (req: AuthenticatedRequest, res: Response) => { 
    try {
      await UserLikesModel.destroy({
        where: {
          username: req.user!.username,
          productId: req.body.productId,
        }
      })
      // TODO - Get Liked Product View Model.
      res.status(StatusCodes.CREATED_CODE);
      return res.json({ 
        status: StatusCodes.CREATED_CODE,
        message: 'Succesfuly liked product.'
      });
    } catch (error) {
      console.error(error);
      const statusCode: number = StatusCodes.INTERNAL_SERVER_ERROR;
      res.status(statusCode);
      return res.json({
        status: statusCode,
        message: 'Failed to submit the specified order to the database.',
        route: `POST ${ likeRouteName }/`
      });
    }
  }
);

export default router;