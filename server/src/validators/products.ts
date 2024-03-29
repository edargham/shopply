import { ValidationChain, body, param } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class ProductValidator {
  // TODO - Size Guard all params.

  public static validateGetSingleProduct(): ValidationChain[] {
    return [
      param('id')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('id')),
    ];
  }
  
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

  public static validateUpdateProduct(): ValidationChain[] {
    return [
      param('id')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('id')),

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
    ]
  }

  public static validateDelete(): ValidationChain[] {
    return [
      param('id')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('id'))
    ]
  }
  
  public static validateUpdateImage(): ValidationChain[] {
    return [
      param('id')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('id'))
    ]
  }

  public static validateSearchParam(): ValidationChain[] {
    return [
      param('title')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('title'))
    ]
  }
}