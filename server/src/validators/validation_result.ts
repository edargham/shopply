import { Request, Response, NextFunction } from 'express';
import { Result, ValidationError, validationResult } from 'express-validator';

import StatusCodes from '../utils/status_codes';

export const checkValidationResult = (req: Request, res: Response, next: NextFunction) => {
  const error: Result<ValidationError> = validationResult(req);
  
  if (!error.isEmpty()) {
    res.status(StatusCodes.BAD_REQUEST);
    return res.json(error);
  }

  next();
}