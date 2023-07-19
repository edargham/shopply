import { ValidationChain, body, param } from 'express-validator';
import ValidatorTemplateMessages from '../utils/validator_template_messages';

export default class SysAdminsValidator {
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
      
      body('lastName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('lastName'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('lastName', 'alphabetic')),

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

  public static validateUserLogin(): ValidationChain[] {
    return [
      body('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlphanumeric()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('username', 'alphanumeric')),

      body('password')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('password'))
      .isLength({ min: 8 })
      .withMessage(ValidatorTemplateMessages.MIN_LENGTH_MESSAGE)
    ];
  }

  public static validateUpdateUser(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username')),
      
      body('firstName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('firstName'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('firstName', 'alphabetic')),
      
      body('lastName')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('lastName'))
      .isLength({ min: 3, max: 16 })
      .withMessage(ValidatorTemplateMessages.OUT_OF_RANGE_MESSAGE)
      .isAlpha()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('lastName', 'alphabetic'))
    ];
  }

  public static validateUserDelete(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username')),

      body('password')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('password'))
      .isLength({ min: 8 })
      .withMessage(ValidatorTemplateMessages.MIN_LENGTH_MESSAGE)
    ];
  }

  public static validateUserChangeEmail(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username')),

      body('email')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('email'))
      .isEmail()
      .withMessage(ValidatorTemplateMessages.typeMismatchSetting('email', 'email'))
    ];
  }

  public static validateUserChangePassword(): ValidationChain[] {
    return [
      param('username')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('username')),

      body('oldPassword')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('Password'))
      .isLength({ min: 8 })
      .withMessage(ValidatorTemplateMessages.MIN_LENGTH_MESSAGE),

      body('password')
      .notEmpty()
      .withMessage(ValidatorTemplateMessages.missingRequirementMessage('password'))
      .isLength({ min: 8 })
      .withMessage(ValidatorTemplateMessages.MIN_LENGTH_MESSAGE)
    ];
  }
}