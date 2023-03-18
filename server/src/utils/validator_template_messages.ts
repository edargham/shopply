export default class ValidatorTemplateMessages {
  public static readonly MAX_LENGTH_MESSAGE: string = 'The length of the specified field exceeds the maximum allowed.';
  public static readonly MIN_LENGTH_MESSAGE: string = 'The length of the specified field falls behind the minimum required.';
  public static readonly OUT_OF_RANGE_MESSAGE: string = 'The length of the specified field is not within the range required.';

  public static typeMismatchSetting(fieldName: string, type: string): string {
    return `The type of ${ fieldName } is does not match the type required (${ type }).`
  }

  public static missingRequirementMessage(fieldName: string): string {
    return `The ${ fieldName } was not supplied.`;
  }
}