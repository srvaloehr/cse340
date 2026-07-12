import db from './db.js';

export async function getAllCategories() {
    const query = 'SELECT category_id, name FROM public.category ORDER BY name;';
    const result = await db.query(query);
    return result.rows;
}