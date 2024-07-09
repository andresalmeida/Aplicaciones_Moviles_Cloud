const { Router } = require('express');
const router = Router();

// MODELO DE BASE DE DATOS
const User = require('../models/User');

// DATOS DE PRUEBA
const { faker } = require('@faker-js/faker');

// GET - Ruta para obtener la lista de usuarios
router.get('/api/user', async (req, res) => {
    try {
        const user = await User.find();
        res.json({user});
    } catch (error) {
        console.error('Error User:', error);
        res.status(500).json({ message: 'Error en el servidor' });
    }
});

// POST - Crear un nuevo usuario
router.post('/api/user', async (req, res) => {
    try {
        const { firstName, lastName, avatar } = req.body;
        const newUser = new User({ firstName, lastName, avatar });
        await newUser.save();
        res.status(201).json(newUser);
    } catch (error) {
        console.error('Error User:', error);
        res.status(500).json({ message: 'Error al crear usuario' });
    }
});


// PUT - Actualizar un usuario existente
router.put('/api/user/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { firstName, lastName, avatar } = req.body;
        const updatedUser = await User.findByIdAndUpdate(id, { firstName, lastName, avatar }, { new: true });
        if (!updatedUser) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        res.json(updatedUser);
    } catch (error) {
        console.error('Error User:', error);
        res.status(500).json({ message: 'Error al actualizar usuario' });
    }
});

// DELETE - Eliminar un usuario
router.delete('/api/user/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const deletedUser = await User.findByIdAndDelete(id);
        if (!deletedUser) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        res.json({ message: 'Usuario eliminado correctamente' });
    } catch (error) {
        console.error('Error User:', error);
        res.status(500).json({ message: 'Error al eliminar usuario' });
    }
});

// Ruta para crear usuarios de prueba
router.get('/api/user/create', async (req, res) => {
    try {
        for (let i = 0; i < 5; i++) {
            const user = new User({
                firstName: faker.person.firstName(),
                lastName: faker.person.lastName(),
                avatar: faker.image.avatar()
            });
            await user.save();
        }
        res.json({ message: '5 users created' });
    } catch (error) {
        console.error('Error User:', error);
        res.status(500).json({ message: 'Error en crear usuario mor' });
    }
});

module.exports = router;
