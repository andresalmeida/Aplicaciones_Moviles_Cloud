// // const {Schema, model} = require('mongoose');

// // const userSchema = new Schema({
// //     firstName: String,
// //     lastName: String,
// //     image :  String
    
// // });

// // model.exports = model('User', userSchema);

const { default: mongoose } = require('mongoose');

const UserSchema = new mongoose.Schema({
    firstName:{
        type: String,
        required: true
    },
    lastName:{
        type: String,
        required: true
    },
    avatar:{
        type: String,
        required: true
    }
});

const User = mongoose.model('User', UserSchema);
module.exports = User;


