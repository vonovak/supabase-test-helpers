BEGIN;
--TODO: For now you have to specify the version due to a bug in pg_tle
-- this should be changed to remove the version once the bug is fixed
-- right now it always installs the FIRST version of the extension
CREATE EXTENSION supabase_test_helpers version '0.0.4';

select plan(8);

select tests.create_supabase_user('test');

select lives_ok($$ select tests.authenticate_as('test') $$, 'Successfully authenticated as test user');
select is((select tests.get_supabase_uid('test')), auth.uid(), 'Authenticates as the correct user');
select is((select current_role::text), 'authenticated', 'Sets the current role to authenticated');

select tests.authenticate_as_service_role();

select is((select current_role::text), 'service_role', 'Sets the current role to service_role');
select is((select auth.uid()), null, 'Clears out authentication');

select lives_ok($$ select tests.authenticate_as('test') $$, 'Successfully authenticated as test user');
select is((select tests.get_supabase_uid('test')), auth.uid(), 'Authenticates as the correct user');
select is((select current_role::text), 'authenticated', 'Sets the current role to authenticated');



select * from finish();
ROLLBACK;