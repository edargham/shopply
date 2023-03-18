export type DestinationCallback = (error: Error | null, destination: string) => void;
export type FileNameCallback = (error: Error | null, filename: string) => void;
export const limits = {
  maxFileSizeMB: 5,
  maxFileNameLength: 256,
  allowedFiles: [
    'image/jpeg',
    'image/png'
  ]
};