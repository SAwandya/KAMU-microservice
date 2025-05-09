const pool = require('../config/database');
const fs = require('fs');
const path = require('path');

async function executeSqlScript() {
    try {
        console.log('Starting database update...');

        // Read the SQL script
        const sqlScript = fs.readFileSync(path.join(__dirname, 'add_image_column.sql'), 'utf8');

        // Split into individual commands (assumes each command ends with ;)
        const commands = sqlScript.split(';').filter(cmd => cmd.trim());

        // Execute each command
        for (const command of commands) {
            if (command.trim()) {
                console.log(`Executing: ${command}`);
                await pool.execute(command);
                console.log('Command executed successfully');
            }
        }

        console.log('Database update completed successfully');
        process.exit(0);
    } catch (error) {
        console.error('Error updating database:', error);
        process.exit(1);
    }
}

executeSqlScript();