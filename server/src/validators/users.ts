import { ValidationChain, body, param } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class UsersValidator {
  // TODO - Size Guard all params.
  
  public static validateGetSingleUser(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username')),
    ];
  }

  public static validateUserSignup(): ValidationChain[] {
    return [
      body('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlphanumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('username', 'alphanumeric')),
      
      body('firstName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('firstName'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('firstName', 'alphabetic')),

      body('middleName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('middleName'))
      .isLength({ max: 16 })
      .withMessage(ValidatorTemplateMessages.MAX_LENGTH_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('middleName', 'alphabetic')),
      
      body('lastName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('lastName'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('lastName', 'alphabetic')),

      body('dateOfBirth')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('dateOfBirth')),

      body('sex')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('sex'))
      .isBoolean()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('sex', 'boolean')),

      body('email')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('email'))
      .isEmail()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('email', 'email')),

      body('phoneNumber')
      .optional()
      .isLength({ min: 8, max: 128})
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isNumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('phoneNumber', 'numeric')),

      body('password')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('password'))
      .isLength({ min: 8 })
      .withMessage(ValidatorTemplateMessages.MIN_LENGTH_MESSAGE)
    ];
  }
}