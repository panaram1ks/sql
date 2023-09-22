ALTER TABLE IF EXISTS company_storage.employee
    ADD COLUMN gender INT;

UPDATE company_storage.employee
SET gender = 1
WHERE id <= 5;

ALTER TABLE company_storage.employee
    ALTER COLUMN gender SET NOT NULL ;

ALTER TABLE company_storage.employee
    DROP COLUMN gender;
