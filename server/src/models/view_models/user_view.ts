export default interface IShopplyUser {
  username: string,
  firstName: string,
  lastName: string,
  email: string,
  phoneNumber: string | null,
  isVerified: boolean | null | undefined,
  ok: boolean | null | undefined,
}