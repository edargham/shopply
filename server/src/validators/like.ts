import { ValidationChain, body } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class LikeValidator {
  public static validate(): ValidationChain[] {
    return [
      body('productId')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('productId')),
      // .isAlpha()
      // .withMessage(ValidatorTemplateMessages.typeMismatchSetting('productId', 'alphanumeric')),
    ];
  }
}