import { Request, Response, NextFunction } from 'express';
import { randomBytes } from 'crypto';
import jwt from 'jsonwebtoken';

import { IUser } from '../models/user';
import StatusCodes from '../utils/status_codes';

export interface AuthenticatedRequest extends Request {
  user?: any
}

export const authToken: string = randomBytes(64).toString('hex');

export const generateAccessToken = (user: IUser, token: string): string => {
  return jwt.sign(user, token);
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
        req.user = user;
        next();
      }
    });
  }
}