import React, { useState, useEffect } from 'react';
import { usePagination } from '../hooks/usePagination';
import { motion, AnimatePresence } from 'motion/react';
import { io } from 'socket.io-client';
import { 
  LayoutDashboard, 
  Users, 
  Building2, 
  Map, 
  Trees, 
  Settings, 
  LogOut, 
  Menu, 
  X, 
  TrendingUp, 
  DollarSign, 
  Activity,
  ShieldCheck,
  Briefcase,
  Search,
  Filter,
  ChevronRight,
  MoreVertical,
  Bell,
  AlertTriangle,
  UserPlus,
  CheckCircle,
  Megaphone,
  Send
} from 'lucide-react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  AreaChart,
  Area,
  PieChart,
  Pie,
  Cell
} from 'recharts';
import Logo from './Logo';
import { LISTED_PROJECTS, LISTED_PLOTS, LISTED_FARM_LANDS, LEADS } from '../data/mockData';

interface SuperAdminDashboardProps {
  onLogout: () => void;
}

const PLATFORM_STATS = [
  { title: "Total Revenue", value: "₹12.4 Cr", trend: "+15.2%", icon: DollarSign, color: "emerald" },
  { title: "Total Partners", value: "1,240", trend: "+42", icon: Users, color: "indigo" },
  { title: "Active Projects", value: "86", trend: "+4", icon: Building2, color: "amber" },
  { title: "Total Leads", value: "4,820", trend: "+124", icon: Activity, color: "blue" },
];

const REVENUE_CHART_DATA = [
  { month: 'Jan', revenue: 4500000 },
  { month: 'Feb', revenue: 5200000 },
  { month: 'Mar', revenue: 4800000 },
  { month: 'Apr', revenue: 6100000 },
  { month: 'May', revenue: 5900000 },
  { month: 'Jun', revenue: 7200000 },
];

const PROPERTY_DISTRIBUTION = [
  { name: 'Projects', value: 45, color: '#4f46e5' },
  { name: 'Plots', value: 30, color: '#10b981' },
  { name: 'Farm Lands', value: 25, color: '#f59e0b' },
];


const HOWZERS_DATA = [
  { name: "Howzy Hyderabad", owner: "Kiran Reddy", agents: 450, revenue: "₹4.2 Cr", status: "Active" },
  { name: "Howzy Bangalore", owner: "Anitha Rao", agents: 320, revenue: "₹3.8 Cr", status: "Active" },
  { name: "Howzy Chennai", owner: "Vijay Kumar", agents: 210, revenue: "₹2.1 Cr", status: "Active" },
  { name: "Howzy Pune", owner: "Sanjay Patil", agents: 180, revenue: "₹1.5 Cr", status: "Pending" },
  { name: "Howzy Vizag", owner: "Ravi Teja", agents: 80, revenue: "₹0.8 Cr", status: "Active" },
];


const PARTNERS_DATA = [
  { name: "Rahul Sharma", franchise: "Hyderabad", status: "Active", deals: 24, earnings: "₹12.5L" },
  { name: "Priya Singh", franchise: "Bangalore", status: "Active", deals: 18, earnings: "₹8.2L" },
  { name: "Amit Patel", franchise: "Pune", status: "Inactive", deals: 5, earnings: "₹1.5L" },
  { name: "Sneha Reddy", franchise: "Hyderabad", status: "Active", deals: 32, earnings: "₹18.4L" },
  { name: "Vikram Rao", franchise: "Chennai", status: "Active", deals: 12, earnings: "₹4.8L" },
];

const MOCK_NOTIFICATIONS = [
  {
    id: 1,
    type: 'partner',
    title: 'New Howzer Onboarded',
    message: 'Howzy Pune has successfully completed onboarding.',
    time: '5 mins ago',
    unread: true,
    icon: UserPlus,
    color: 'indigo'
  },
  {
    id: 2,
    type: 'stock',
    title: 'Low Stock Alert',
    message: 'Prestige High Fields has only 3 units remaining.',
    time: '1 hour ago',
    unread: true,
    icon: AlertTriangle,
    color: 'amber'
  },
  {
    id: 3,
    type: 'revenue',
    title: 'Revenue Milestone',
    message: 'Platform revenue crossed ₹12 Cr this month!',
    time: '3 hours ago',
    unread: false,
    icon: TrendingUp,
    color: 'emerald'
  },
  {
    id: 4,
    type: 'partner',
    title: 'New Howzer Request',
    message: 'Howzy Vizag is requesting access to the platform.',
    time: '5 hours ago',
    unread: false,
    icon: ShieldCheck,
    color: 'blue'
  },
];

export default function SuperAdminDashboard({ onLogout }: SuperAdminDashboardProps) {
  const [activeTab, setActiveTab] = useState('overview');
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [notifications, setNotifications] = useState(MOCK_NOTIFICATIONS);

  const unreadCount = notifications.filter(n => n.unread).length;

  const markAllAsRead = () => {
    setNotifications(notifications.map(n => ({ ...n, unread: false })));
  };

  const tabs = React.useMemo(() => [
    { id: 'overview', label: 'Overview', icon: LayoutDashboard },
    { id: 'franchises', label: 'Howzer Management', icon: ShieldCheck },
    { id: 'agents', label: 'Partner Management', icon: Users },
    { id: 'projects', label: 'All Projects', icon: Building2 },
    { id: 'plots', label: 'All Plots', icon: Map },
    { id: 'farmlands', label: 'All Farm Lands', icon: Trees },
    { id: 'leads', label: 'Global Leads', icon: Briefcase },
    { id: 'alerts', label: 'Messages & Alerts', icon: Megaphone },
    { id: 'settings', label: 'System Settings', icon: Settings },
  ], []);

  const socketRef = React.useRef<any>(null);

  useEffect(() => {
    socketRef.current = io();
    socketRef.current.emit('join', 'admin');
    return () => {
      socketRef.current.disconnect();
    };
  }, []);

  const handleBroadcast = React.useCallback((notification: any) => {
    if (socketRef.current) {
      socketRef.current.emit('send-broadcast', notification);
    }
  }, []);

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 flex overflow-hidden">
      {/* Mobile Sidebar Toggle */}
      <button 
        className="md:hidden fixed top-4 left-4 z-50 p-2 bg-white rounded-lg border border-slate-200 shadow-sm"
        onClick={() => setSidebarOpen(!sidebarOpen)}
      >
        {sidebarOpen ? <X className="w-6 h-6 text-slate-600" /> : <Menu className="w-6 h-6 text-slate-600" />}
      </button>

      {/* Sidebar */}
      <aside className={`
        fixed md:static inset-y-0 left-0 z-40 w-72 bg-white border-r border-slate-200 transform transition-transform duration-300 ease-in-out shadow-lg md:shadow-none
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'}
      `}>
        <div className="p-8 flex flex-col h-full">
          <div className="flex items-center mb-10">
            <Logo className="h-10" animated={true} />
            <motion.span 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.6, duration: 0.5 }}
              className="text-[10px] uppercase tracking-[0.2em] font-bold text-indigo-600 mt-1 bg-indigo-50 px-2 py-1 rounded-md ml-2"
            >
              Super Admin
            </motion.span>
          </div>

          <nav className="space-y-1.5 flex-1 overflow-y-auto pr-2 custom-scrollbar">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <motion.button
                  whileHover={{ x: 4 }}
                  whileTap={{ scale: 0.98 }}
                  key={tab.id}
                  onClick={() => { setActiveTab(tab.id); setSidebarOpen(false); }}
                  className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl transition-all ${
                    isActive 
                      ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/20 font-bold' 
                      : 'text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-semibold'
                  }`}
                >
                  <Icon className={`w-5 h-5 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                  <span className="text-sm">{tab.label}</span>
                  {isActive && (
                    <motion.div 
                      layoutId="activeTab"
                      className="ml-auto w-1.5 h-1.5 bg-white rounded-full"
                    />
                  )}
                </motion.button>
              );
            })}
          </nav>

          <div className="pt-8 mt-8 border-t border-slate-100">
            <div className="bg-slate-50 rounded-2xl p-4 mb-6">
              <div className="flex items-center gap-3 mb-3">
                <div className="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600 font-bold text-xs">
                  SA
                </div>
                <div>
                  <p className="text-xs font-bold text-slate-900">Super Admin</p>
                  <p className="text-[10px] text-slate-500">admin@howzy.com</p>
                </div>
              </div>
            </div>
            <motion.button 
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={onLogout}
              className="w-full flex items-center gap-3 px-4 py-3.5 text-slate-500 hover:text-red-600 hover:bg-red-50 rounded-2xl transition-all font-bold text-sm"
            >
              <LogOut className="w-5 h-5" />
              <span>Sign Out</span>
            </motion.button>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 h-screen overflow-y-auto bg-slate-50/50">
        <header className="h-20 bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-30 px-8 flex items-center justify-between">
          <h2 className="text-xl font-bold text-slate-900">
            {tabs.find(t => t.id === activeTab)?.label}
          </h2>
          
          <div className="flex items-center gap-6">
            <div className="relative hidden md:block">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input 
                type="text" 
                placeholder="Search platform..."
                className="bg-slate-100 border-none rounded-xl py-2 pl-10 pr-4 text-sm w-64 focus:ring-2 focus:ring-indigo-500/20 transition-all"
              />
            </div>
            <div className="relative">
              <button 
                onClick={() => setShowNotifications(!showNotifications)}
                className={`relative p-2 rounded-xl transition-all ${
                  showNotifications ? 'bg-indigo-50 text-indigo-600' : 'text-slate-400 hover:text-slate-600 hover:bg-slate-100'
                }`}
              >
                <Bell className="w-5 h-5" />
                {unreadCount > 0 && (
                  <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full border-2 border-white" />
                )}
              </button>

              <AnimatePresence>
                {showNotifications && (
                  <>
                    <div 
                      className="fixed inset-0 z-40" 
                      onClick={() => setShowNotifications(false)} 
                    />
                    <motion.div
                      initial={{ opacity: 0, y: 10, scale: 0.95 }}
                      animate={{ opacity: 1, y: 0, scale: 1 }}
                      exit={{ opacity: 0, y: 10, scale: 0.95 }}
                      className="absolute right-0 mt-4 w-96 bg-white border border-slate-200 rounded-[2rem] shadow-2xl z-50 overflow-hidden"
                    >
                      <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
                        <h3 className="font-bold text-slate-900">Notifications</h3>
                        <button 
                          onClick={markAllAsRead}
                          className="text-[10px] uppercase font-black text-indigo-600 hover:text-indigo-700 tracking-wider"
                        >
                          Mark all as read
                        </button>
                      </div>
                      <div className="max-h-[400px] overflow-y-auto custom-scrollbar">
                        {notifications.length > 0 ? (
                          <div className="divide-y divide-slate-50">
                            {notifications.map((notification) => {
                              const Icon = notification.icon;
                              return (
                                <div 
                                  key={notification.id} 
                                  className={`p-5 flex gap-4 hover:bg-slate-50 transition-colors cursor-pointer ${
                                    notification.unread ? 'bg-indigo-50/30' : ''
                                  }`}
                                >
                                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${
                                    notification.color === 'indigo' ? 'bg-indigo-100 text-indigo-600' :
                                    notification.color === 'amber' ? 'bg-amber-100 text-amber-600' :
                                    notification.color === 'emerald' ? 'bg-emerald-100 text-emerald-600' :
                                    'bg-blue-100 text-blue-600'
                                  }`}>
                                    <Icon className="w-5 h-5" />
                                  </div>
                                  <div className="flex-1 min-w-0">
                                    <div className="flex items-center justify-between mb-1">
                                      <p className="text-sm font-bold text-slate-900 truncate">{notification.title}</p>
                                      <span className="text-[10px] text-slate-400 font-medium">{notification.time}</span>
                                    </div>
                                    <p className="text-xs text-slate-500 leading-relaxed">{notification.message}</p>
                                  </div>
                                  {notification.unread && (
                                    <div className="w-2 h-2 bg-indigo-600 rounded-full mt-2 shrink-0" />
                                  )}
                                </div>
                              );
                            })}
                          </div>
                        ) : (
                          <div className="p-12 text-center">
                            <div className="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4">
                              <Bell className="w-8 h-8 text-slate-300" />
                            </div>
                            <p className="text-sm font-bold text-slate-900">No notifications</p>
                            <p className="text-xs text-slate-500 mt-1">We'll alert you when something happens</p>
                          </div>
                        )}
                      </div>
                      <div className="p-4 bg-slate-50/50 border-t border-slate-100 text-center">
                        <button className="text-xs font-bold text-slate-500 hover:text-slate-900 transition-colors">
                          View all notifications
                        </button>
                      </div>
                    </motion.div>
                  </>
                )}
              </AnimatePresence>
            </div>
          </div>
        </header>

        <div className="p-8 max-w-7xl mx-auto">
          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.3 }}
            >
              
              {React.useMemo(() => {
                switch (activeTab) {
                  case 'overview': return <AdminOverview />;
                  case 'partners': return <PartnerManagement />;
                  case 'builders': return <PilotManagement />;
                  case 'projects': return <AllPropertiesView type="Projects" data={LISTED_PROJECTS} />;
                  case 'plots': return <AllPropertiesView type="Plots" data={LISTED_PLOTS} />;
                  case 'farmlands': return <AllPropertiesView type="Farm Lands" data={LISTED_FARM_LANDS} />;
                  case 'leads': return <GlobalLeadsView />;
                  case 'alerts': return <MessagesAndAlertsView onBroadcast={handleBroadcast} />;
                  case 'settings': return <SystemSettings />;
                  default: return null;
                }
              }, [activeTab, handleBroadcast])}

            </motion.div>
          </AnimatePresence>
        </div>
      </main>
    </div>
  );
}

const MessagesAndAlertsView = React.memo(function MessagesAndAlertsView({ onBroadcast }: { onBroadcast: (notif: any) => void }) {
  const [title, setTitle] = useState('');
  const [message, setMessage] = useState('');
  const [type, setType] = useState('info');
  const [isSending, setIsSending] = useState(false);
  const [sentCount, setSentCount] = useState(0);

  const handleSend = () => {
    if (!title || !message) return;
    setIsSending(true);
    
    // Simulate network delay
    setTimeout(() => {
      onBroadcast({
        title,
        message,
        type,
        icon: type === 'alert' ? 'AlertTriangle' : type === 'success' ? 'CheckCircle' : 'Megaphone',
        color: type === 'alert' ? 'amber' : type === 'success' ? 'emerald' : 'indigo'
      });
      
      setIsSending(false);
      setSentCount(prev => prev + 1);
      setTitle('');
      setMessage('');
      
      // Auto-hide success message after 3s
      setTimeout(() => setSentCount(0), 3000);
    }, 800);
  };

  return (
    <div className="space-y-8">
      <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
        <div className="flex items-center gap-4 mb-8">
          <div className="w-12 h-12 bg-indigo-100 rounded-2xl flex items-center justify-center text-indigo-600">
            <Megaphone className="w-6 h-6" />
          </div>
          <div>
            <h3 className="text-xl font-bold text-slate-900">Broadcast to All Partners</h3>
            <p className="text-sm text-slate-500">Send a platform-wide notification to all registered pilots instantly.</p>
          </div>
        </div>

        <div className="space-y-6 max-w-2xl">
          <div>
            <label className="block text-sm font-bold text-slate-700 mb-2">Notification Title</label>
            <input 
              type="text" 
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="e.g., New Training Session Available"
              className="w-full bg-slate-50 border-slate-200 rounded-xl py-3 px-4 text-sm focus:ring-2 focus:ring-indigo-500/20 transition-all"
            />
          </div>

          <div>
            <label className="block text-sm font-bold text-slate-700 mb-2">Message Content</label>
            <textarea 
              rows={4}
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              placeholder="Enter the detailed message for pilots..."
              className="w-full bg-slate-50 border-slate-200 rounded-xl py-3 px-4 text-sm focus:ring-2 focus:ring-indigo-500/20 transition-all resize-none"
            />
          </div>

          <div>
            <label className="block text-sm font-bold text-slate-700 mb-2">Notification Type</label>
            <div className="flex gap-4">
              {['info', 'alert', 'success'].map((t) => (
                <button
                  key={t}
                  onClick={() => setType(t)}
                  className={`px-6 py-2 rounded-xl text-xs font-bold capitalize transition-all border ${
                    type === t 
                      ? 'bg-indigo-600 text-white border-indigo-600 shadow-lg shadow-indigo-600/20' 
                      : 'bg-white text-slate-500 border-slate-200 hover:border-slate-300'
                  }`}
                >
                  {t}
                </button>
              ))}
            </div>
          </div>

          <div className="pt-4">
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleSend}
              disabled={!title || !message || isSending}
              className="flex items-center gap-2 px-8 py-3.5 bg-indigo-600 text-white rounded-2xl font-bold text-sm shadow-xl shadow-indigo-600/20 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
            >
              {isSending ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <Send className="w-4 h-4" />
              )}
              <span>{isSending ? 'Sending Broadcast...' : 'Send to All Partners'}</span>
            </motion.button>
            
            <AnimatePresence>
              {sentCount > 0 && (
                <motion.p
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0 }}
                  className="text-emerald-600 text-xs font-bold mt-4 flex items-center gap-2"
                >
                  <CheckCircle className="w-4 h-4" />
                  Broadcast sent successfully to all active pilots!
                </motion.p>
              )}
            </AnimatePresence>
          </div>
        </div>
      </div>

      <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
        <h3 className="text-lg font-bold text-slate-900 mb-6">Recent Broadcast History</h3>
        <div className="space-y-4">
          {[
            { title: "System Maintenance", time: "2 days ago", reach: "1,240 pilots", type: "alert" },
            { title: "New Commission Structure", time: "1 week ago", reach: "1,180 pilots", type: "success" },
            { title: "Welcome to Howzy Partner", time: "2 weeks ago", reach: "1,050 partners", type: "info" },
          ].map((item, i) => (
            <div key={i} className="flex items-center justify-between p-4 bg-slate-50 rounded-2xl">
              <div className="flex items-center gap-4">
                <div className={`w-2 h-2 rounded-full ${
                  item.type === 'alert' ? 'bg-amber-500' : 
                  item.type === 'success' ? 'bg-emerald-500' : 'bg-indigo-500'
                }`} />
                <div>
                  <p className="text-sm font-bold text-slate-900">{item.title}</p>
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider mt-0.5">{item.time} • Reached {item.reach}</p>
                </div>
              </div>
              <button className="text-slate-400 hover:text-slate-600">
                <MoreVertical className="w-4 h-4" />
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
});

const AdminOverview = React.memo(function AdminOverview() {
  return (
    <div className="space-y-8">
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {PLATFORM_STATS.map((stat, i) => (
          <StatCard key={i} {...stat} />
        ))}
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h3 className="text-lg font-bold text-slate-900">Revenue Growth</h3>
              <p className="text-sm text-slate-500">Platform-wide revenue performance</p>
            </div>
            <select className="bg-slate-50 border-none rounded-lg text-xs font-bold text-slate-600 py-2 px-3">
              <option>Last 6 Months</option>
              <option>Last Year</option>
            </select>
          </div>
          <div className="h-[350px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={REVENUE_CHART_DATA}>
                <defs>
                  <linearGradient id="colorRev" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#4f46e5" stopOpacity={0.1}/>
                    <stop offset="95%" stopColor="#4f46e5" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} dy={10} />
                <YAxis axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} tickFormatter={(v) => `₹${v/10000000}Cr`} />
                <Tooltip 
                  contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)' }}
                />
                <Area type="monotone" dataKey="revenue" stroke="#4f46e5" strokeWidth={3} fillOpacity={1} fill="url(#colorRev)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
          <h3 className="text-lg font-bold text-slate-900 mb-2">Property Mix</h3>
          <p className="text-sm text-slate-500 mb-8">Distribution of listings</p>
          <div className="h-[250px] w-full relative">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={PROPERTY_DISTRIBUTION}
                  innerRadius={60}
                  outerRadius={80}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {PROPERTY_DISTRIBUTION.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
            <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
              <span className="text-2xl font-black text-slate-900">100%</span>
              <span className="text-[10px] uppercase font-bold text-slate-400">Total</span>
            </div>
          </div>
          <div className="space-y-3 mt-6">
            {PROPERTY_DISTRIBUTION.map((item, i) => (
              <div key={i} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full" style={{ backgroundColor: item.color }} />
                  <span className="text-sm font-medium text-slate-600">{item.name}</span>
                </div>
                <span className="text-sm font-bold text-slate-900">{item.value}%</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
        <div className="flex items-center justify-between mb-8">
          <h3 className="text-lg font-bold text-slate-900">Recent Platform Activity</h3>
          <button className="text-indigo-600 text-sm font-bold hover:underline">View All Logs</button>
        </div>
        <div className="space-y-6">
          {[
            { user: "Partner 007", action: "Closed a deal", target: "Prestige High Fields", time: "2 mins ago", icon: CheckCircle },
            { user: "Howzer HYD", action: "Added new partner", target: "Suresh Kumar", time: "15 mins ago", icon: UserPlus },
            { user: "System", action: "New project approved", target: "My Home Sayuk", time: "1 hour ago", icon: Building2 },
            { user: "Howzer BLR", action: "Revenue payout requested", target: "₹4.5L", time: "3 hours ago", icon: DollarSign },
          ].map((activity, i) => (
            <div key={i} className="flex items-center justify-between py-2 border-b border-slate-50 last:border-0">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center text-slate-400">
                  <activity.icon className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-sm font-bold text-slate-900">
                    <span className="text-indigo-600">{activity.user}</span> {activity.action} <span className="text-slate-500">{activity.target}</span>
                  </p>
                  <p className="text-xs text-slate-400 font-medium">{activity.time}</p>
                </div>
              </div>
              <button className="p-2 text-slate-300 hover:text-slate-600 transition-colors">
                <MoreVertical className="w-4 h-4" />
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
});

const StatCard = React.memo(function StatCard({ title, value, trend, icon: Icon, color }: any) {
  const colors: any = {
    emerald: "bg-emerald-50 text-emerald-600 border-emerald-100",
    indigo: "bg-indigo-50 text-indigo-600 border-indigo-100",
    amber: "bg-amber-50 text-amber-600 border-amber-100",
    blue: "bg-blue-50 text-blue-600 border-blue-100",
  };

  return (
    <motion.div 
      whileHover={{ y: -5 }}
      className="bg-white border border-slate-200 p-6 rounded-[2rem] shadow-sm hover:shadow-xl hover:shadow-indigo-500/5 transition-all group"
    >
      <div className="flex items-center justify-between mb-4">
        <div className={`w-12 h-12 rounded-2xl flex items-center justify-center border ${colors[color]}`}>
          <Icon className="w-6 h-6" />
        </div>
        <div className="flex items-center gap-1 px-2 py-1 bg-emerald-50 text-emerald-600 rounded-full text-[10px] font-black border border-emerald-100">
          <TrendingUp className="w-3 h-3" />
          {trend}
        </div>
      </div>
      <p className="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">{title}</p>
      <h4 className="text-2xl font-black text-slate-900 font-mono">{value}</h4>
    </motion.div>
  );
});

const PartnerManagement = React.memo(function PartnerManagement() {
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h3 className="text-2xl font-bold text-slate-900">Howzers</h3>
          <p className="text-slate-500">Manage and monitor Howzer performance</p>
        </div>
        <button className="bg-indigo-600 text-white px-6 py-3 rounded-2xl font-bold text-sm shadow-lg shadow-indigo-600/20 hover:bg-indigo-700 transition-all">
          + Onboard New Howzer
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {HOWZERS_DATA.map((franchise, i) => (
          <motion.div 
            whileHover={{ y: -4 }}
            key={i} 
            className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm"
          >
            <div className="flex justify-between items-start mb-6">
              <div className="w-12 h-12 bg-slate-50 rounded-2xl flex items-center justify-center text-indigo-600">
                <Building2 className="w-6 h-6" />
              </div>
              <span className={`px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider border ${
                franchise.status === 'Active' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 'bg-amber-50 text-amber-600 border-amber-100'
              }`}>
                {franchise.status}
              </span>
            </div>
            <h4 className="text-lg font-bold text-slate-900 mb-1">{franchise.name}</h4>
            <p className="text-sm text-slate-500 mb-6">Owner: {franchise.owner}</p>
            
            <div className="grid grid-cols-2 gap-4 pt-6 border-t border-slate-50">
              <div>
                <p className="text-[10px] uppercase font-bold text-slate-400 mb-1">Partners</p>
                <p className="text-lg font-black text-slate-900">{franchise.agents}</p>
              </div>
              <div>
                <p className="text-[10px] uppercase font-bold text-slate-400 mb-1">Revenue</p>
                <p className="text-lg font-black text-emerald-600 font-mono">{franchise.revenue}</p>
              </div>
            </div>
            
            <button className="w-full mt-6 py-3 bg-slate-50 hover:bg-slate-100 text-slate-600 font-bold text-xs rounded-xl transition-all flex items-center justify-center gap-2">
              Manage Howzer <ChevronRight className="w-4 h-4" />
            </button>
          </motion.div>
        ))}
      </div>
    </div>
  );
});

const PilotManagement = React.memo(function PilotManagement() {
  const [searchTerm, setSearchTerm] = useState('');
  const filteredPartners = React.useMemo(() => {
    return PARTNERS_DATA.filter(p => p.name.toLowerCase().includes(searchTerm.toLowerCase()) || p.franchise.toLowerCase().includes(searchTerm.toLowerCase()));
  }, [searchTerm]);
  
  const { currentData: paginatedPartners, currentPage, maxPage, next, prev } = usePagination(filteredPartners, 10);

  return (
    <div className="bg-white border border-slate-200 rounded-[2rem] overflow-hidden shadow-sm">
      <div className="p-8 border-b border-slate-100 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h3 className="text-xl font-bold text-slate-900">Partner Directory</h3>
          <p className="text-sm text-slate-500">Total 1,240 partners across all Howzers</p>
        </div>
        <div className="flex items-center gap-3 w-full md:w-auto">
          <div className="relative flex-1 md:w-64">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input type="text" placeholder="Search partners..." className="w-full bg-slate-50 border-none rounded-xl py-2 pl-10 pr-4 text-sm" value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
          </div>
          <button className="p-2 bg-slate-50 rounded-xl text-slate-400 hover:text-slate-600 transition-colors">
            <Filter className="w-5 h-5" />
          </button>
        </div>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full text-left">
          <thead>
            <tr className="bg-slate-50/50 text-[10px] uppercase font-bold text-slate-400 tracking-widest">
              <th className="px-8 py-4">Partner Name</th>
              <th className="px-8 py-4">Howzer</th>
              <th className="px-8 py-4">Status</th>
              <th className="px-8 py-4">Total Deals</th>
              <th className="px-8 py-4">Earnings</th>
              <th className="px-8 py-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-50">
            {paginatedPartners.map((agent, i) => (
              <tr key={i} className="hover:bg-slate-50/50 transition-colors group">
                <td className="px-8 py-5">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 font-bold text-sm">
                      {agent.name.charAt(0)}
                    </div>
                    <span className="font-bold text-slate-900">{agent.name}</span>
                  </div>
                </td>
                <td className="px-8 py-5 text-sm text-slate-500 font-medium">{agent.franchise}</td>
                <td className="px-8 py-5">
                  <span className={`px-2 py-1 rounded-md text-[10px] font-bold ${
                    agent.status === 'Active' ? 'bg-emerald-50 text-emerald-600' : 'bg-slate-100 text-slate-400'
                  }`}>
                    {agent.status}
                  </span>
                </td>
                <td className="px-8 py-5 text-sm font-bold text-slate-900">{agent.deals}</td>
                <td className="px-8 py-5 text-sm font-mono font-bold text-emerald-600">{agent.earnings}</td>
                <td className="px-8 py-5 text-right">
                  <button className="p-2 text-slate-300 hover:text-indigo-600 transition-colors">
                    <ChevronRight className="w-5 h-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {maxPage > 1 && (
        <div className="p-4 border-t border-slate-100 flex items-center justify-between">
          <span className="text-sm text-slate-500">Page {currentPage} of {maxPage}</span>
          <div className="flex gap-2">
            <button onClick={prev} disabled={currentPage === 1} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Prev</button>
            <button onClick={next} disabled={currentPage === maxPage} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Next</button>
          </div>
        </div>
      )}
    </div>
  );
});

const AllPropertiesView = React.memo(function AllPropertiesView({ type, data }: { type: string, data: any[] }) {
  const { currentData: displayData, currentPage, maxPage, next, prev } = usePagination(data, 10);

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h3 className="text-2xl font-bold text-slate-900">Global {type}</h3>
          <p className="text-slate-500">Monitoring all {type.toLowerCase()} across the platform</p>
        </div>
        <div className="flex gap-3">
          <button className="bg-white border border-slate-200 text-slate-600 px-6 py-3 rounded-2xl font-bold text-sm hover:bg-slate-50 transition-all">
            Export Report
          </button>
          <button className="bg-indigo-600 text-white px-6 py-3 rounded-2xl font-bold text-sm shadow-lg shadow-indigo-600/20 hover:bg-indigo-700 transition-all">
            + Add New {type.slice(0, -1)}
          </button>
        </div>
      </div>

      <div className="bg-white border border-slate-200 rounded-[2rem] overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead>
              <tr className="bg-slate-50/50 text-[10px] uppercase font-bold text-slate-400 tracking-widest">
                <th className="px-8 py-4">Property Name</th>
                <th className="px-8 py-4">Developer</th>
                <th className="px-8 py-4">Location</th>
                <th className="px-8 py-4">Status</th>
                <th className="px-8 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {displayData.map((item, i) => (
                <tr key={i} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-8 py-5">
                    <span className="font-bold text-slate-900">{item.name}</span>
                  </td>
                  <td className="px-8 py-5 text-sm text-indigo-600 font-medium">{item.developerName || item.builderName}</td>
                  <td className="px-8 py-5 text-sm text-slate-500 font-medium">{item.location}</td>
                  <td className="px-8 py-5">
                    <span className="px-2 py-1 bg-emerald-50 text-emerald-600 rounded-md text-[10px] font-bold">
                      Verified
                    </span>
                  </td>
                  <td className="px-8 py-5 text-right">
                    <button className="p-2 text-slate-300 hover:text-indigo-600 transition-colors">
                      <MoreVertical className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
      </div>
      {maxPage > 1 && (
        <div className="p-4 border-t border-slate-100 flex items-center justify-between">
          <span className="text-sm text-slate-500">Page {currentPage} of {maxPage}</span>
          <div className="flex gap-2">
            <button onClick={prev} disabled={currentPage === 1} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Prev</button>
            <button onClick={next} disabled={currentPage === maxPage} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Next</button>
          </div>
        </div>
      )}
    </div>
  </div>
  );
});

const GlobalLeadsView = React.memo(function GlobalLeadsView() {
  const { currentData: displayLeads, currentPage, maxPage, next, prev } = usePagination(LEADS, 10);

  return (
    <div className="bg-white border border-slate-200 rounded-[2rem] overflow-hidden shadow-sm">
      <div className="p-8 border-b border-slate-100">
        <h3 className="text-xl font-bold text-slate-900">Platform-wide Leads</h3>
        <p className="text-sm text-slate-500">Real-time lead generation across all regions</p>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full text-left">
          <thead>
            <tr className="bg-slate-50/50 text-[10px] uppercase font-bold text-slate-400 tracking-widest">
              <th className="px-8 py-4">Lead Name</th>
              <th className="px-8 py-4">Assigned Pilot</th>
              <th className="px-8 py-4">Partner</th>
              <th className="px-8 py-4">Stage</th>
              <th className="px-8 py-4 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-50">
            {displayLeads.map((lead, i) => (
              <tr key={i} className="hover:bg-slate-50/50 transition-colors">
                <td className="px-8 py-5">
                  <span className="font-bold text-slate-900">{lead.name}</span>
                </td>
                <td className="px-8 py-5 text-sm text-slate-600 font-medium">Partner 007</td>
                <td className="px-8 py-5 text-sm text-slate-500 font-medium">Hyderabad</td>
                <td className="px-8 py-5">
                  <span className="px-2 py-1 bg-indigo-50 text-indigo-600 rounded-md text-[10px] font-bold">
                    {lead.milestone}
                  </span>
                </td>
                <td className="px-8 py-5 text-right">
                  <button className="p-2 text-slate-300 hover:text-indigo-600 transition-colors">
                    <ChevronRight className="w-5 h-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {maxPage > 1 && (
        <div className="p-4 border-t border-slate-100 flex items-center justify-between">
          <span className="text-sm text-slate-500">Page {currentPage} of {maxPage}</span>
          <div className="flex gap-2">
            <button onClick={prev} disabled={currentPage === 1} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Prev</button>
            <button onClick={next} disabled={currentPage === maxPage} className="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg disabled:opacity-50">Next</button>
          </div>
        </div>
      )}
    </div>
  );
});

const SystemSettings = React.memo(function SystemSettings() {
  return (
    <div className="max-w-3xl space-y-8">
      <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
        <h3 className="text-lg font-bold text-slate-900 mb-6">Platform Configuration</h3>
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-bold text-slate-900">Maintenance Mode</p>
              <p className="text-xs text-slate-500">Disable platform access for all users</p>
            </div>
            <button className="w-12 h-6 bg-slate-200 rounded-full relative">
              <div className="absolute left-1 top-1 w-4 h-4 bg-white rounded-full" />
            </button>
          </div>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-bold text-slate-900">Automatic Payouts</p>
              <p className="text-xs text-slate-500">Process franchise payouts automatically every month</p>
            </div>
            <button className="w-12 h-6 bg-indigo-600 rounded-full relative">
              <div className="absolute right-1 top-1 w-4 h-4 bg-white rounded-full" />
            </button>
          </div>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-bold text-slate-900">Lead Auto-Assignment</p>
              <p className="text-xs text-slate-500">Use AI to assign leads to best performing pilots</p>
            </div>
            <button className="w-12 h-6 bg-indigo-600 rounded-full relative">
              <div className="absolute right-1 top-1 w-4 h-4 bg-white rounded-full" />
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white border border-slate-200 rounded-[2rem] p-8 shadow-sm">
        <h3 className="text-lg font-bold text-slate-900 mb-6">Security & Access</h3>
        <div className="space-y-4">
          <button className="w-full text-left px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-bold text-slate-700 transition-all">
            Manage Super Admin Roles
          </button>
          <button className="w-full text-left px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-bold text-slate-700 transition-all">
            View Audit Logs
          </button>
          <button className="w-full text-left px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-bold text-slate-700 transition-all">
            API Configuration
          </button>
        </div>
      </div>
    </div>
  );
});
