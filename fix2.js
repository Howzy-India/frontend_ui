import fs from 'fs';
import path from 'path';

const filePath = path.join(process.cwd(), 'src/components/SuperAdminDashboard.tsx');
let content = fs.readFileSync(filePath, 'utf8');

content = content.replace(/\}\);\);\n/g, '});\n');

fs.writeFileSync(filePath, content, 'utf8');
console.log('Fixed syntax errors');
