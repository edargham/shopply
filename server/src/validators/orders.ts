import { ValidationChain, body, param, query } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class OrdersValidator {
  public static validateGetQuery(): ValidationChain[] {
    return [
      query('status')
      .optional()
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('status', 'numeric'))
    ];
  }

  public static validateGetByUsernameQuery(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlphanumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('username', 'alphanumeric')),

      query('status')
      .optional()
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('status', 'numeric')),
    ];
  }

  public static validateSubmitOrder(): ValidationChain[] {
    return [
      body('amountPaid')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('amountPaid'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('amountPaid', 'numeric')),

      body('status')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('status'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('amountPaid', 'numeric')),

      body('cartItems')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('cartItems'))
      .isArray()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('amountPaid', 'numeric')),

      body('cartItems.*.productId')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('productId')),

      body('cartItems.*.quantity')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('quantity'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('quantity', 'numeric')),

      body('cartItems.*.price')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('price'))
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('price', 'numeric')),

      body('cartItems.*.title')
      .optional(),
    ];
  }
}