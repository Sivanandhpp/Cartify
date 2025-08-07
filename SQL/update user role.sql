-- Query to update user role to admin
-- This query updates a specific user's role and timestamp
-- Valid roles: 'buyer', 'seller', 'admin'

-- First, verify the user exists and check current role
SELECT 
    id,
    phone_number,
    name,
    email,
    role,
    created_at,
    updated_at
FROM public.users 
WHERE id = '98eccfdf-1508-4577-ade8-76e79fb197fc';

-- Update user role to admin
UPDATE public.users
SET 
    role = 'seller',
    updated_at = NOW()
WHERE id = '98eccfdf-1508-4577-ade8-76e79fb197fc';

-- Verify the update was successful
SELECT 
    id,
    phone_number,
    name,
    email,
    role,
    updated_at
FROM public.users 
WHERE id = '98eccfdf-1508-4577-ade8-76e79fb197fc';