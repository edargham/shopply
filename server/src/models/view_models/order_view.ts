import { IVwCartItem } from "../cart_item";
import { IOrder, OrderStatus } from "../order";

export default class OrderViewModel implements IOrder {
  _id:                 string;
  _amountPaid:         number;
  _dateOrdered:          Date;
  _username:           string;
  _statusId:           number;
  _items:  IVwCartItem[] | null;

  //#region Constructors
  constructor(
    id:                 string,
    amountPaid:         number,
    dateOrdered:          Date,
    username:           string,
    statusId:           number,
    items:  IVwCartItem[] | null=null
  ) {
    this._id          = id;
    this._amountPaid  = amountPaid;
    this._dateOrdered = dateOrdered;
    this._username    = username;
    this._statusId    = statusId;
    this._items       = items;
  }
  //#endregion

  //#region Getters
  public get id(): string {
    return this._id;
  }
  
  public get amountPaid(): number {
    return this._amountPaid;
  }
  
  public get dateOrdered(): Date {
    return this._dateOrdered;
  }

  public get username(): string {
    return this._username;
  }
  
  public get statusId(): number {
    return this._statusId;
  }
  
  public get status(): OrderStatus {
    return this._statusId;
  }
  
  public get items(): IVwCartItem[] | null {
    return this._items;
  }
  //#endregion

  //#region Setters
  public set id(identifier: string) {
    this._id = identifier;
  }

  public set amountPaid(value: number) {
    this._amountPaid = value;
  }

  public set dateOrdered(date: Date) {
    this._dateOrdered = date;
  }
  
  public set username(userName: string) {
    this.username = userName;
  }
  
  public set status(orderStatus: OrderStatus) {
    this._statusId = orderStatus;
  }
  
  public set items(cartItems: IVwCartItem[] | null) {
    this._items = cartItems;
  }
  //#endregion
}