import { ValidationChain, body, param } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class ProductValidator {
  public static validateCreateProduct(): ValidationChain[] {
    return [
      body('title')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('title'))
      .isLength({ max: 128 })
      .withMessage(ValidatorTemplateMessages.MAX_LENGTH_MESSAGE),
      body('description')
      .optional()
      .isLength({ min: 16, max: 4096 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE),
      body('price')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('price'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('price', 'numeric')),
      body('stock')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('stock'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('stock', 'numeric'))
    ];
  }
}