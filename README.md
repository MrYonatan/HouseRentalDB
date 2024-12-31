 <h1>House Rental Database Management System</h1>
    <h2>Overview</h2>
    <p>
        This project demonstrates the design and implementation of a 
        <strong>House Rental Management System</strong> using SQL. It includes a structured database schema, 
        CRUD operations, advanced features like triggers, views, and stored procedures, along with backup and 
        restore mechanisms.
    </p>
    <hr>
    <h2>Features</h2>
    <ul>
        <li><strong>Schema Design</strong>: Logical tables for managing tenants, house owners, rental houses, contracts, payments, and contact details.</li>
        <li><strong>Relationships</strong>: Properly linked foreign keys ensuring data integrity.</li>
        <li><strong>Triggers & Functions</strong>: Includes triggers to prevent duplicates and functions for calculating payments and late fees.</li>
        <li><strong>Views</strong>: Simplified access to structured data for users.</li>
        <li><strong>Procedures</strong>: Automates the process of inserting and updating data across multiple tables.</li>
        <li><strong>Transaction Management</strong>: Ensures data consistency during complex operations.</li>
        <li><strong>Backup Strategy</strong>: Full and transaction log backups for data safety.</li>
    </ul>
    <hr>
    <h2>Key Tables</h2>
    <ol>
        <li><strong>Region_cod</strong>: Contains details about house regions.</li>
        <li><strong>Rent_house</strong>: Stores rental house attributes.</li>
        <li><strong>House_Owner</strong> & <strong>Tenant</strong>: Manages owners and tenants.</li>
        <li><strong>House_contract</strong>: Tracks rental agreements.</li>
        <li><strong>Payment</strong>: Stores payment details.</li>
    </ol>
    <hr>
    <h2>Highlights</h2>
    <ul>
        <li><strong>Data Retrieval</strong>: Queries for advanced joins and conditional filtering.</li>
        <li><strong>Triggers</strong>: Prevents duplicate IDs during inserts.</li>
        <li><strong>Backup Implementation</strong>: Includes full and log-based backups.</li>
    </ul>
