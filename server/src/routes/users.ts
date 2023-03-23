import { Router, Request, Response } from 'express';
import multer, { Multer, StorageEngine, FileFilterCallback } from 'multer';
import { Model } from 'sequelize';
import { v4 } from 'uuid';
import { mkdirSync, existsSync, removeSync } from 'fs-extra';

import { physicalRootDir } from '../config/server.config';
import { DestinationCallback, FileNameCallback, limits } from '../config/multer.config';

import { UserModel, IUser } from '../models/user';

import StatusCodes from '../utils/status_codes';

import { checkValidationResult } from '../validators/validation_result';

export const productsRouteName: string = '/api/users';
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

router.post('/signup');


router.post('/login');


router.get('/:username');


router.patch('/:username');


router.delete('/:username');


router.patch('/change-photo/:username');


router.patch('/change-email/:username');


router.patch('/change-password/:username');


router.patch('/change-phone/:username');


export default router;