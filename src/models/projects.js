import db from './db.js';

export async function getAllProjects() {
    const query = `
        SELECT p.project_id, p.title, p.description, p.location, p.project_date,
               o.name AS organization_name
        FROM public.project p
        JOIN public.organization o
          ON p.organization_id = o.organization_id
        ORDER BY p.project_date;
    `;
    const result = await db.query(query);
    return result.rows;
}