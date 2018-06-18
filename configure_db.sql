UPDATE identifier_domain SET universal_identifier_type_code = 'ISO'
WHERE namespace_identifier = '2.16.840.1.113883.4.357';

INSERT INTO identifier_domain (identifier_domain_id, identifier_domain_name, identifier_domain_description, universal_identifier, universal_identifier_type_code, namespace_identifier, date_created, creator_id) VALUES
(81, 'OpenMRS Old ID', 'OpenMRS Old Identification Number', '2.16.840.1.113883.3.7194.2.1', 'ISO', 'OpenMRS Old ID', current_timestamp, -1),
(82, 'OpenMRS ID', 'OpenMRS Identification Number', '2.16.840.1.113883.3.7194.2.2', 'ISO', 'OpenMRS ID', current_timestamp, -1);
