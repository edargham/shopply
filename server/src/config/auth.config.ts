import { Request, Response, NextFunction } from 'express';
import { randomBytes } from 'crypto';
import jwt from 'jsonwebtoken';

import { IUser } from '../models/user';
import { ISysAdmin } from '../models/sys_admin';
import IShopplyUser from '../models/view_models/user_view';

import StatusCodes from '../utils/status_codes';

export interface AuthenticatedRequest extends Request {
  user?: IShopplyUser
}

export const authToken: string = randomBytes(64).toString('hex');

export const generateAccessToken = (user: IUser, token: string): string => {
  const shopplyUser: IShopplyUser = {
    username: user.username,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    phoneNumber: user.phoneNumber,
    isVerified: user.isVerified,
    ok: undefined,
  }
  return jwt.sign(shopplyUser, token);
}

export const generateAccessTokenAdmin = (user: ISysAdmin, token: string): string => {
  const shopplyUser: IShopplyUser = {
    username: user.username,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    phoneNumber: user.phoneNumber,
    isVerified: undefined,
    ok: true,
  }
  return jwt.sign(shopplyUser, token);
}

export const authenticateToken = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  const authHeader: string | undefined = req.headers.authorization;

  if (!authHeader) {
    const statusCode: number = StatusCodes.UNAUTHORIZED;
    res.status(statusCode);

    return res.json({
      status: statusCode,
      message: 'You must be logged in to access this content.'
    });
  } else {
    const token: string = authHeader.split(' ')[1];
    if (!token) {
      const statusCode: number = StatusCodes.UNAUTHORIZED;
      res.status(statusCode);
  
      return res.json({
        status: statusCode,
        message: 'You must be logged in to access this content.'
      });
    }

    jwt.verify(token, authToken, (error: any, user: any) => {
      if (error) {
        const statusCode: number = StatusCodes.FORBIDDEN;
        res.status(statusCode);

        return res.json({
          status: statusCode,
          message: `FORBIDDEN\n${ error }`
        });
      } else {
        req.user = {
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          isVerified: user.isVerified,
          ok: user.ok
        };
        next();
      }
    });
  }
}

export const escalatePrivilages = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  if (req.user?.ok) {
    next();
  } else {
    const statusCode: number = StatusCodes.FORBIDDEN;
    res.status(statusCode);

    return res.json({
      status: statusCode,
      message: `FORBIDDEN\nYou are not authorized to access this content.`
    });
  }
}

export const acceptToken = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  const authHeader: string | undefined = req.headers.authorization;

  if (!authHeader) {
    next();
  } else {
    const token: string = authHeader.split(' ')[1];
    if (!token) {
      const statusCode: number = StatusCodes.UNAUTHORIZED;
      res.status(statusCode);
  
      return res.json({
        status: statusCode,
        message: 'Invalid token.'
      });
    }

    jwt.verify(token, authToken, (error: any, user: any) => {
      if (error) {
        const statusCode: number = StatusCodes.FORBIDDEN;
        res.status(statusCode);

        return res.json({
          status: statusCode,
          message: `FORBIDDEN\n${ error }`
        });
      } else {
        req.user = {
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          isVerified: user.isVerified,
          ok: user.ok
        };
        next();
      }
    });
  }
}

export const authorizeSelf = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  if (req.user && req.user.username != req.params.username) {
    const statusCode: number = StatusCodes.FORBIDDEN;
    res.status(statusCode);

    return res.json({
      status: statusCode,
      message: 'You are not allowed to access this content.'
    });
  } else {
    next();
  }
}