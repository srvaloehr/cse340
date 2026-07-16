-- Delete the tables in reverse relationship order.
-- This allows the setup script to be run again without foreign-key errors.
DROP TABLE IF EXISTS public.project_category;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.project;
DROP TABLE IF EXISTS public.organization;


-- =========================================================
-- ORGANIZATION TABLE
-- =========================================================

CREATE TABLE public.organization (
    organization_id SERIAL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL,

    CONSTRAINT organization_pk
        PRIMARY KEY (organization_id)
);


INSERT INTO public.organization (
    name,
    description,
    contact_email,
    logo_filename
)
VALUES
(
    'BrightFuture Builders',
    'A nonprofit focused on improving community infrastructure through sustainable construction projects.',
    'info@brightfuturebuilders.org',
    'brightfuture-logo.png'
),
(
    'GreenHarvest Growers',
    'An urban farming collective promoting food sustainability and education in local neighborhoods.',
    'contact@greenharvest.org',
    'greenharvest-logo.png'
),
(
    'UnityServe Volunteers',
    'A volunteer coordination group supporting local charities and service initiatives.',
    'hello@unityserve.org',
    'unityserve-logo.png'
);


-- =========================================================
-- PROJECT TABLE
-- =========================================================

CREATE TABLE public.project (
    project_id SERIAL,
    organization_id INTEGER NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    project_date DATE NOT NULL,

    CONSTRAINT project_pk
        PRIMARY KEY (project_id),

    CONSTRAINT project_organization_fk
        FOREIGN KEY (organization_id)
        REFERENCES public.organization(organization_id)
);


-- Each organization has five projects.
INSERT INTO public.project (
    organization_id,
    title,
    description,
    location,
    project_date
)
VALUES
(
    1,
    'Park Cleanup',
    'Remove litter and prepare the neighborhood park for community use.',
    'Sunrise Community Park',
    '2026-08-08'
),
(
    2,
    'Food Drive',
    'Collect and organize nonperishable food for local families.',
    'GreenHarvest Community Center',
    '2026-08-22'
),
(
    3,
    'Coat Collection',
    'Collect gently used coats for people in need during the winter.',
    'UnityServe Main Office',
    '2026-09-05'
),
(
    1,
    'Senior Visits',
    'Visit senior residents and help with simple household activities.',
    'Mesa Senior Living Center',
    '2026-09-19'
),
(
    2,
    'Trail Repair',
    'Repair damaged sections of a local walking trail.',
    'Desert View Trail',
    '2026-10-03'
),
(
    3,
    'Blood Drive',
    'Support a community blood donation event.',
    'Unity Community Hall',
    '2026-10-17'
),
(
    1,
    'School Supplies',
    'Collect backpacks and school supplies for students.',
    'BrightFuture Learning Center',
    '2026-11-07'
),
(
    2,
    'River Cleanup',
    'Remove trash and debris from the river shoreline.',
    'Salt River Recreation Area',
    '2026-11-21'
),
(
    3,
    'Holiday Meals',
    'Prepare and distribute holiday meals to local families.',
    'UnityServe Kitchen',
    '2026-12-12'
),
(
    1,
    'Tutoring Night',
    'Provide homework assistance and tutoring for local students.',
    'BrightFuture Learning Center',
    '2027-01-09'
),
(
    2,
    'Habitat Build',
    'Help construct and repair housing for a local family.',
    'East Mesa Build Site',
    '2027-01-23'
),
(
    3,
    'Garden Planting',
    'Plant vegetables and prepare community garden beds.',
    'Unity Community Garden',
    '2027-02-06'
),
(
    1,
    'Toy Drive',
    'Collect new toys for children in need.',
    'BrightFuture Main Office',
    '2027-02-20'
),
(
    2,
    'Warm Socks Drive',
    'Collect new socks for shelters and outreach programs.',
    'GreenHarvest Community Center',
    '2027-03-06'
),
(
    3,
    'Neighborhood Raking',
    'Help senior residents remove leaves and yard debris.',
    'Unity Neighborhood District',
    '2027-03-20'
);


-- =========================================================
-- CATEGORY TABLE
-- =========================================================

CREATE TABLE public.category (
    category_id SERIAL,
    name VARCHAR(50) NOT NULL,

    CONSTRAINT category_pk
        PRIMARY KEY (category_id),

    CONSTRAINT category_name_unique
        UNIQUE (name)
);


INSERT INTO public.category (name)
VALUES
    ('Environment'),
    ('Community Support'),
    ('Youth & Education'),
    ('Health');


-- =========================================================
-- PROJECT-CATEGORY JUNCTION TABLE
-- =========================================================

CREATE TABLE public.project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,

    CONSTRAINT project_category_pk
        PRIMARY KEY (project_id, category_id),

    CONSTRAINT project_category_project_fk
        FOREIGN KEY (project_id)
        REFERENCES public.project(project_id)
        ON DELETE CASCADE,

    CONSTRAINT project_category_category_fk
        FOREIGN KEY (category_id)
        REFERENCES public.category(category_id)
        ON DELETE CASCADE
);


-- Every project is connected to at least one category.
-- Some projects have more than one category to demonstrate
-- the many-to-many relationship.
INSERT INTO public.project_category (
    project_id,
    category_id
)
VALUES
    (1, 1),  -- Park Cleanup: Environment

    (2, 2),  -- Food Drive: Community Support
    (2, 4),  -- Food Drive: Health

    (3, 2),  -- Coat Collection: Community Support
    (4, 2),  -- Senior Visits: Community Support
    (5, 1),  -- Trail Repair: Environment
    (6, 4),  -- Blood Drive: Health
    (7, 3),  -- School Supplies: Youth & Education
    (8, 1),  -- River Cleanup: Environment
    (9, 2),  -- Holiday Meals: Community Support

    (10, 3), -- Tutoring Night: Youth & Education
    (10, 2), -- Tutoring Night: Community Support

    (11, 2), -- Habitat Build: Community Support

    (12, 1), -- Garden Planting: Environment
    (12, 3), -- Garden Planting: Youth & Education

    (13, 3), -- Toy Drive: Youth & Education
    (14, 2), -- Warm Socks Drive: Community Support
    (15, 2); -- Neighborhood Raking: Community Support


-- =========================================================
-- VERIFICATION QUERIES
-- =========================================================

SELECT
    organization_id,
    name,
    description,
    contact_email,
    logo_filename
FROM public.organization
ORDER BY organization_id;


SELECT
    p.project_id,
    p.title,
    p.description,
    p.location,
    p.project_date,
    o.name AS organization_name
FROM public.project AS p
JOIN public.organization AS o
    ON p.organization_id = o.organization_id
ORDER BY p.project_date;


SELECT
    category_id,
    name
FROM public.category
ORDER BY name;


SELECT
    p.title AS project_title,
    c.name AS category_name
FROM public.project AS p
JOIN public.project_category AS pc
    ON p.project_id = pc.project_id
JOIN public.category AS c
    ON pc.category_id = c.category_id
ORDER BY p.project_id, c.name;