import React from 'react';
import { motion } from 'motion/react';
import { 
  Building2, 
  TrendingUp, 
  Users, 
  DollarSign,
  LogOut,
  Activity,
  UserPlus,
  Construction,
  ArrowRight
} from 'lucide-react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  LineChart,
  Line
} from 'recharts';
import Logo from './Logo';
import BuilderOnboardingModal from './BuilderOnboardingModal';

interface PartnerDashboardProps {
  onLogout: () => void;
}

const ONBOARDING_DATA = [
  { name: 'Jan', onboarded: 40 },
  { name: 'Feb', onboarded: 30 },
  { name: 'Mar', onboarded: 50 },
  { name: 'Apr', onboarded: 80 },
  { name: 'May', onboarded: 60 },
  { name: 'Jun', onboarded: 90 },
];

const TEAM_PERFORMANCE = [
  { name: 'Howzer 007', onboarded: 12, target: 45 },
  { name: 'Howzer 042', onboarded: 8, target: 32 },
  { name: 'Howzer 015', onboarded: 5, target: 18 },
  { name: 'Howzer 088', onboarded: 3, target: 12 },
];

export default function PartnerDashboard({ onLogout }: PartnerDashboardProps) {
  const [isBuilderModalOpen, setIsBuilderModalOpen] = React.useState(false);

  return (
    <div className="min-h-screen bg-transparent text-slate-900 flex flex-col">
      {/* Top Navigation */}
      <header className="bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center sticky top-0 z-50 shadow-sm">
        <div className="flex items-center">
          <Logo className="h-8" animated={true} />
          <motion.span 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.6, duration: 0.5 }}
            className="text-xs font-bold uppercase tracking-wider text-slate-500 bg-slate-100 px-2 py-1 rounded-md ml-2"
          >
            Howzer
          </motion.span>
        </div>
        
        <motion.button 
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={onLogout}
          className="flex items-center gap-2 text-slate-600 hover:text-red-600 transition-colors bg-slate-50 hover:bg-red-50 border border-slate-200 hover:border-red-100 px-4 py-2 rounded-lg text-sm font-medium"
        >
          <LogOut className="w-4 h-4" />
          Logout
        </motion.button>
      </header>

      {/* Main Content */}
      <main className="flex-1 p-6 md:p-10 max-w-7xl mx-auto w-full space-y-8">
        
        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatCard 
            title="Partners Onboarded" 
            value="124" 
            trend="+12" 
            icon={Users} 
            color="emerald" 
          />
          <StatCard 
            title="Builders Onboarded" 
            value="42" 
            trend="+3" 
            icon={Building2} 
            color="indigo" 
          />
          <StatCard 
            title="Projects Listed" 
            value="156" 
            trend="+24" 
            icon={Activity} 
            color="amber" 
          />
          <StatCard 
            title="Pending Approvals" 
            value="18" 
            trend="-2" 
            icon={UserPlus} 
            color="blue" 
          />
        </div>

        {/* Charts Section */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <motion.div 
            whileHover={{ y: -2 }}
            className="lg:col-span-2 bg-white border border-slate-200 rounded-2xl p-6 shadow-sm hover:shadow-md transition-all"
          >
            <h3 className="text-lg font-bold text-slate-900 mb-6">Onboarding Overview</h3>
            <div className="h-[300px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={ONBOARDING_DATA}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" vertical={false} />
                  <XAxis dataKey="name" stroke="#64748b" axisLine={false} tickLine={false} />
                  <YAxis stroke="#64748b" axisLine={false} tickLine={false} />
                  <Tooltip 
                    contentStyle={{ backgroundColor: '#ffffff', borderColor: '#e2e8f0', borderRadius: '8px', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                    itemStyle={{ color: '#4f46e5', fontWeight: 600 }}
                  />
                  <Line type="monotone" dataKey="onboarded" stroke="#4f46e5" strokeWidth={3} dot={{ r: 4, fill: '#4f46e5', strokeWidth: 2, stroke: '#ffffff' }} activeDot={{ r: 6 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </motion.div>

          <motion.div 
            whileHover={{ y: -2 }}
            className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm hover:shadow-md transition-all"
          >
            <h3 className="text-lg font-bold text-slate-900 mb-6">Top Performing Howzers</h3>
            <div className="space-y-6">
              {TEAM_PERFORMANCE.map((agent, i) => (
                <div key={i} className="flex items-center justify-between p-2 hover:bg-slate-50 rounded-xl transition-colors">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-slate-700 font-bold border border-slate-200">
                      {agent.name.split(' ')[1]}
                    </div>
                    <div>
                      <p className="text-sm font-bold text-slate-900">{agent.name}</p>
                      <p className="text-xs text-slate-500 font-medium">{agent.onboarded} onboarded</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-mono font-bold text-emerald-600">{agent.target} target</p>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        </div>

        {/* Onboarding Section */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <motion.div 
            whileHover={{ y: -2 }}
            className="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl p-8 text-white shadow-lg shadow-indigo-500/20 relative overflow-hidden group cursor-pointer"
          >
            <div className="absolute top-0 right-0 p-8 opacity-10 transform group-hover:scale-110 transition-transform duration-500">
              <UserPlus className="w-32 h-32" />
            </div>
            <div className="relative z-10">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mb-6 backdrop-blur-sm border border-white/30">
                <UserPlus className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-2xl font-bold mb-2">Onboard Partner</h3>
              <p className="text-indigo-100 mb-6 max-w-xs">
                Invite and register a new Howzy Partner to your franchise network.
              </p>
              <button className="flex items-center gap-2 bg-white text-indigo-600 px-6 py-3 rounded-xl font-bold hover:bg-indigo-50 transition-colors shadow-sm">
                Start Onboarding <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </motion.div>

          <motion.div 
            whileHover={{ y: -2 }}
            className="bg-gradient-to-br from-emerald-500 to-teal-600 rounded-2xl p-8 text-white shadow-lg shadow-emerald-500/20 relative overflow-hidden group cursor-pointer"
          >
            <div className="absolute top-0 right-0 p-8 opacity-10 transform group-hover:scale-110 transition-transform duration-500">
              <Construction className="w-32 h-32" />
            </div>
            <div className="relative z-10">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mb-6 backdrop-blur-sm border border-white/30">
                <Construction className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-2xl font-bold mb-2">Onboard Builder</h3>
              <p className="text-emerald-100 mb-6 max-w-xs">
                Register a new builder or developer to list their properties on Howzy.
              </p>
              <button 
                onClick={() => setIsBuilderModalOpen(true)}
                className="flex items-center gap-2 bg-white text-emerald-600 px-6 py-3 rounded-xl font-bold hover:bg-emerald-50 transition-colors shadow-sm"
              >
                Start Onboarding <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </motion.div>
        </div>

      </main>

      <BuilderOnboardingModal 
        isOpen={isBuilderModalOpen} 
        onClose={() => setIsBuilderModalOpen(false)} 
      />
    </div>
  );
}

function StatCard({ title, value, trend, icon: Icon, color }: any) {
  const colorMap: Record<string, string> = {
    emerald: 'text-emerald-600 bg-emerald-50 border-emerald-100',
    indigo: 'text-indigo-600 bg-indigo-50 border-indigo-100',
    amber: 'text-amber-600 bg-amber-50 border-amber-100',
    blue: 'text-blue-600 bg-blue-50 border-blue-100',
  };

  return (
    <motion.div 
      whileHover={{ y: -4, scale: 1.02 }}
      className="bg-white border border-slate-200 rounded-2xl p-6 relative overflow-hidden group hover:border-slate-300 hover:shadow-lg transition-all"
    >
      <div className="flex justify-between items-start mb-4">
        <div className={`p-3 rounded-xl border ${colorMap[color]}`}>
          <Icon className="w-6 h-6" />
        </div>
        <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-2 py-1 rounded-full border border-emerald-200">
          {trend}
        </span>
      </div>
      <h3 className="text-slate-500 text-sm font-semibold mb-1">{title}</h3>
      <p className="text-3xl font-bold text-slate-900 font-mono">{value}</p>
    </motion.div>
  );
}
