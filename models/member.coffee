mg = require "mongoose"
{Schema} = mg

MemberSchema = new Schema
  fullName: { type: String, trim: true }
  lastName: { type: String, trim: true }
  firstName: { type: String, trim: true }
  middleName: { type: String, trim: true }
  brotherName: { type: String, trim: true }
  male: Boolean
  position: { type: String, trim: true }
  birthDate: Date
  angelDate: Date
  photoId: { type: String, trim: true }
  phone: String
  email: String
  skype: String
  info: String
  active: { type: Boolean, default: yes }
  reserved: { type: Boolean, default: no }
  orderNumber: { type: Number, default: 50 }
  created: { type: Date, default: Date.now }
  updated: { type: Date, default: Date.now }

exports.Member = mg.model('Member', MemberSchema)