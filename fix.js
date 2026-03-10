import fs from 'fs';
import path from 'path';

const filePath = path.join(process.cwd(), 'src/components/SuperAdminDashboard.tsx');
let content = fs.readFileSync(filePath, 'utf8');

// Fix missing }); for React.memo
// Find all occurrences of `  );\n}` that should be `  );\n});`
// We will just do a global replace for the specific components.

const componentsToFix = [
  'AdminOverview',
  'StatCard',
  'PartnerManagement',
  'PilotManagement',
  'AllPropertiesView',
  'GlobalLeadsView',
  'MessagesAndAlertsView',
  'SystemSettings'
];

// Let's just use a regex to find the end of each component and replace it.
// A component ends with:
//   );
// }
// followed by either EOF or another component definition.

content = content.replace(/  \);\n\}/g, '  );\n});');

// Wait, SuperAdminDashboard itself is NOT wrapped in React.memo.
// So we need to revert the one for SuperAdminDashboard.
content = content.replace(/export default function SuperAdminDashboard\(\{ onLogout \}: SuperAdminDashboardProps\) \{[\s\S]*?  \);\n\}\);/g, (match) => {
  return match.replace(/  \);\n\}\);$/, '  );\n}');
});

// Fix HOWZERS_DATA.map and PARTNERS_DATA.map
content = content.replace(/HOWZERS_DATA\.map/g, '{HOWZERS_DATA.map');
content = content.replace(/PARTNERS_DATA\.map/g, '{filteredPartners.map'); // Wait, I already replaced this.
// Let's check what it currently is.
content = content.replace(/\{HOWZERS_DATA\.map/g, 'HOWZERS_DATA.map'); // Reset first
content = content.replace(/HOWZERS_DATA\.map/g, '{HOWZERS_DATA.map');

content = content.replace(/\{filteredPartners\.map/g, 'filteredPartners.map'); // Reset first
content = content.replace(/filteredPartners\.map/g, '{filteredPartners.map');

// Fix the closing braces for the maps
// Actually, the original code had `{[ ... ].map(...) }`.
// My previous script replaced `{[ ... ].map` with `HOWZERS_DATA.map`.
// So it became `HOWZERS_DATA.map(...) }`.
// Which means there is an extra `}` at the end.
// Let's just replace `HOWZERS_DATA.map` with `{HOWZERS_DATA.map`.
// And `filteredPartners.map` with `{filteredPartners.map`.

// But wait, the original was `{[ ... ].map`. I replaced `{[ ... ].map` with `HOWZERS_DATA.map`.
// So it became `HOWZERS_DATA.map`. The closing `}` was left as is.
// So if I add `{` before `HOWZERS_DATA`, it will match the closing `}`.

// Let's write the file.
fs.writeFileSync(filePath, content, 'utf8');
console.log('Fixed syntax errors');
