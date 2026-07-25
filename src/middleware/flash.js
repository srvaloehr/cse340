/**
 * Flash Message Middleware
 * req.flash('success', 'text')  -> store a message
 * req.flash('error')            -> get + clear one type
 * flash()                       -> get + clear all (used in templates)
 */
const flashMiddleware = (req, res, next) => {
    req.flash = function (type, message) {
        if (!req.session.flash) {
            req.session.flash = { success: [], error: [], warning: [], info: [] };
        }

        // SET (two args)
        if (type && message) {
            if (!req.session.flash[type]) req.session.flash[type] = [];
            req.session.flash[type].push(message);
            return;
        }

        // GET ONE TYPE (one arg)
        if (type && !message) {
            const messages = req.session.flash[type] || [];
            req.session.flash[type] = [];
            return messages;
        }

        // GET ALL (no args)
        const allMessages = req.session.flash || { success: [], error: [], warning: [], info: [] };
        req.session.flash = { success: [], error: [], warning: [], info: [] };
        return allMessages;
    };

    next();
};

const flashLocals = (req, res, next) => {
    res.locals.flash = req.flash; // make flash() available in all EJS templates
    next();
};

const flash = (req, res, next) => {
    flashMiddleware(req, res, () => {
        flashLocals(req, res, next);
    });
};

export default flash;