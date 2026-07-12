CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);



INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

CREATE TABLE public.category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO public.category (name) VALUES
('Environment'),
('Community Support'),
('Youth & Education'),
('Health');

CREATE TABLE public.project_category (
    project_id INT NOT NULL REFERENCES public.project(project_id),
    category_id INT NOT NULL REFERENCES public.category(category_id),
    PRIMARY KEY (project_id, category_id)
);

INSERT INTO public.project_category (project_id, category_id) VALUES
(1, 1),   -- Park Cleanup → Environment
(2, 2),   -- Food Drive → Community Support
(3, 2),   -- Coat Collection → Community Support
(4, 2),   -- Senior Visits → Community Support
(5, 1),   -- Trail Repair → Environment
(6, 4),   -- Blood Drive → Health
(7, 3),   -- School Supplies → Youth & Education
(8, 1),   -- River Cleanup → Environment
(9, 2),   -- Holiday Meals → Community Support
(10, 3),  -- Tutoring Night → Youth & Education
(11, 2),  -- Habitat Build → Community Support
(12, 1),  -- Garden Planting → Environment
(13, 3),  -- Toy Drive → Youth & Education
(14, 2),  -- Warm Socks Drive → Community Support
(15, 2);  -- Neighborhood Raking → Community Support

SELECT p.title, c.name AS category
FROM public.project p
JOIN public.project_category pc ON p.project_id = pc.project_id
JOIN public.category c ON pc.category_id = c.category_id
ORDER BY p.project_id;

