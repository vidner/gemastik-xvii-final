--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cwe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cwe (
    id INTEGER PRIMARY KEY,
    title TEXT,
    description TEXT
);

CREATE TABLE public.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE public.salt (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    salt VARCHAR(255)
);

--
-- Data for Name: cwe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cwe (id,title,description) VALUES
    (20,'CWE-20: Improper Input Validation','The product receives input or data, but it does not validate or incorrectly validates that the input has the properties that are required to process the data safely and correctly.'),
    (22,'CWE-22: Improper Limitation of a Pathname to a Restricted Directory (''Path Traversal'')','The product uses external input to construct a pathname that is intended to identify a file or directory that is located underneath a restricted parent directory, but the product does not properly neutralize special elements within the pathname that can cause the pathname to resolve to a location that is outside of the restricted directory.'),
    (73,'CWE-73: External Control of File Name or Path','The product allows user input to control or influence paths or file names that are used in filesystem operations.'),
    (77,'CWE-77: Improper Neutralization of Special Elements used in a Command (''Command Injection'')','The product constructs all or part of a command using externally-influenced input from an upstream component, but it does not neutralize or incorrectly neutralizes special elements that could modify the intended command when it is sent to a downstream component.'),
    (78,'CWE-78: Improper Neutralization of Special Elements used in an OS Command (''OS Command Injection'')','The product constructs all or part of an OS command using externally-influenced input from an upstream component, but it does not neutralize or incorrectly neutralizes special elements that could modify the intended OS command when it is sent to a downstream component.'),
    (79,'CWE-79: Improper Neutralization of Input During Web Page Generation (''Cross-site Scripting'')','The product does not neutralize or incorrectly neutralizes user-controllable input before it is placed in output that is used as a web page that is served to other users.'),
    (88,'CWE-88: Improper Neutralization of Argument Delimiters in a Command (''Argument Injection'')','The product constructs a string for a command to be executed by a separate component in another control sphere, but it does not properly delimit the intended arguments, options, or switches within that command string.'),
    (89,'CWE-89: Improper Neutralization of Special Elements used in an SQL Command (''SQL Injection'')','The product constructs all or part of an SQL command using externally-influenced input from an upstream component, but it does not neutralize or incorrectly neutralizes special elements that could modify the intended SQL command when it is sent to a downstream component. Without sufficient removal or quoting of SQL syntax in user-controllable inputs, the generated SQL query can cause those inputs to be interpreted as SQL instead of ordinary user data.'),
    (94,'CWE-94: Improper Control of Generation of Code (''Code Injection'')','The product constructs all or part of a code segment using externally-influenced input from an upstream component, but it does not neutralize or incorrectly neutralizes special elements that could modify the syntax or behavior of the intended code segment.'),
    (119,'CWE-119: Improper Restriction of Operations within the Bounds of a Memory Buffer','The product performs operations on a memory buffer, but it reads from or writes to a memory location outside the buffer''s intended boundary. This may result in read or write operations on unexpected memory locations that could be linked to other variables, data structures, or internal program data.');
INSERT INTO public.cwe (id,title,description) VALUES
    (125,'CWE-125: Out-of-bounds Read','The product reads data past the end, or before the beginning, of the intended buffer.'),
    (190,'CWE-190: Integer Overflow or Wraparound','The product performs a calculation that can produce an integer overflow or wraparound when the logic assumes that the resulting value will always be larger than the original value. This occurs when an integer value is incremented to a value that is too large to store in the associated representation. When this occurs, the value may become a very small or negative number.'),
    (200,'CWE-200: Exposure of Sensitive Information to an Unauthorized Actor','The product exposes sensitive information to an actor that is not explicitly authorized to have access to that information.'),
    (250,'CWE-250: Execution with Unnecessary Privileges','The product performs an operation at a privilege level that is higher than the minimum level required, which creates new weaknesses or amplifies the consequences of other weaknesses.'),
    (266,'CWE-266: Incorrect Privilege Assignment','A product incorrectly assigns a privilege to a particular actor, creating an unintended sphere of control for that actor.'),
    (269,'CWE-269: Improper Privilege Management','The product does not properly assign, modify, track, or check privileges for an actor, creating an unintended sphere of control for that actor.'),
    (276,'CWE-276: Incorrect Default Permissions','During installation, installed file permissions are set to allow anyone to modify those files.'),
    (284,'CWE-284: Improper Access Control','The product does not restrict or incorrectly restricts access to a resource from an unauthorized actor.'),
    (285,'CWE-285: Improper Authorization','The product does not perform or incorrectly performs an authorization check when an actor attempts to access a resource or perform an action.'),
    (287,'CWE-287: Improper Authentication','When an actor claims to have a given identity, the product does not prove or insufficiently proves that the claim is correct.');
INSERT INTO public.cwe (id,title,description) VALUES
    (295,'CWE-295: Improper Certificate Validation','The product does not validate, or incorrectly validates, a certificate.'),
    (306,'CWE-306: Missing Authentication for Critical Function','The product does not perform any authentication for functionality that requires a provable user identity or consumes a significant amount of resources.'),
    (307,'CWE-307: Improper Restriction of Excessive Authentication Attempts','The product does not implement sufficient measures to prevent multiple failed authentication attempts within a short time frame, making it more susceptible to brute force attacks.'),
    (311,'CWE-311: Missing Encryption of Sensitive Data','The product does not encrypt sensitive or critical information before storage or transmission.'),
    (327,'CWE-327: Use of a Broken or Risky Cryptographic Algorithm','The product uses a broken or risky cryptographic algorithm or protocol.'),
    (330,'CWE-330: Use of Insufficiently Random Values','The product uses insufficiently random numbers or values in a security context that depends on unpredictable numbers.'),
    (352,'CWE-352: Cross-Site Request Forgery (CSRF)','The web application does not, or can not, sufficiently verify whether a well-formed, valid, consistent request was intentionally provided by the user who submitted the request.'),
    (362,'CWE-362: Concurrent Execution using Shared Resource with Improper Synchronization (''Race Condition'')','The product contains a code sequence that can run concurrently with other code, and the code sequence requires temporary, exclusive access to a shared resource, but a timing window exists in which the shared resource can be modified by another code sequence that is operating concurrently.'),
    (400,'CWE-400: Uncontrolled Resource Consumption','The product does not properly control the allocation and maintenance of a limited resource, thereby enabling an actor to influence the amount of resources consumed, eventually leading to the exhaustion of available resources.'),
    (416,'CWE-416: Use After Free','The product reuses or references memory after it has been freed. At some point afterward, the memory may be allocated again and saved in another pointer, while the original pointer references a location somewhere within the new allocation. Any operations using the original pointer are no longer valid because the memory "belongs" to the code that operates on the new pointer.');
INSERT INTO public.cwe (id,title,description) VALUES
    (426,'CWE-426: Untrusted Search Path','The product searches for critical resources using an externally-supplied search path that can point to resources that are not under the product''s direct control.'),
    (434,'CWE-434: Unrestricted Upload of File with Dangerous Type','The product allows the upload or transfer of dangerous file types that are automatically processed within its environment.'),
    (476,'CWE-476: NULL Pointer Dereference','The product dereferences a pointer that it expects to be valid but is NULL.'),
    (502,'CWE-502: Deserialization of Untrusted Data','The product deserializes untrusted data without sufficiently verifying that the resulting data will be valid.'),
    (522,'CWE-522: Insufficiently Protected Credentials','The product transmits or stores authentication credentials, but it uses an insecure method that is susceptible to unauthorized interception and/or retrieval.'),
    (611,'CWE-611: Improper Restriction of XML External Entity Reference','The product processes an XML document that can contain XML entities with URIs that resolve to documents outside of the intended sphere of control, causing the product to embed incorrect documents into its output.'),
    (732,'CWE-732: Incorrect Permission Assignment for Critical Resource','The product specifies permissions for a security-critical resource in a way that allows that resource to be read or modified by unintended actors.'),
    (754,'CWE-754: Improper Check for Unusual or Exceptional Conditions','The product does not check or incorrectly checks for unusual or exceptional conditions that are not expected to occur frequently during day to day operation of the product.'),
    (772,'CWE-772: Missing Release of Resource after Effective Lifetime','The product does not release a resource after its effective lifetime has ended, i.e., after the resource is no longer needed.'),
    (787,'CWE-787: Out-of-bounds Write','The product writes data past the end, or before the beginning, of the intended buffer.');
INSERT INTO public.cwe (id,title,description) VALUES
    (798,'CWE-798: Use of Hard-coded Credentials','The product contains hard-coded credentials, such as a password or cryptographic key.'),
    (862,'CWE-862: Missing Authorization','The product does not perform an authorization check when an actor attempts to access a resource or perform an action.'),
    (863,'CWE-863: Incorrect Authorization','The product performs an authorization check when an actor attempts to access a resource or perform an action, but it does not correctly perform the check. This allows attackers to bypass intended access restrictions.'),
    (918,'CWE-918: Server-Side Request Forgery (SSRF)','The web server receives a URL or similar request from an upstream component and retrieves the contents of this URL, but it does not sufficiently ensure that the request is being sent to the expected destination.');


--
-- Name: cwe cwe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--
-- PostgreSQL database dump complete
--
