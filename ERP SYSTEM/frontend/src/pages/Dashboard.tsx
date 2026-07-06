import React from 'react';
import { motion } from 'framer-motion';
import { 
  TrendingUp, 
  TrendingDown, 
  AlertTriangle, 
  Settings, 
  CheckCircle2, 
  Activity, 
  Cpu, 
  ShieldAlert,
  Sparkles,
  Search,
  MessageSquare
} from 'lucide-react';
import { 
  AreaChart, 
  Area, 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell
} from 'recharts';

// Mock Data
const revenueData = [
  { name: 'Jan', revenue: 45000, cost: 28000 },
  { name: 'Feb', revenue: 52000, cost: 31000 },
  { name: 'Mar', revenue: 49000, cost: 29000 },
  { name: 'Apr', revenue: 63000, cost: 35000 },
  { name: 'May', revenue: 58000, cost: 33000 },
  { name: 'Jun', revenue: 71000, cost: 38000 },
];

const productionData = [
  { name: 'Smart Motor V2', target: 500, actual: 480 },
  { name: 'Control Units', target: 350, actual: 365 },
  { name: 'Robotic Cables', target: 800, actual: 690 },
  { name: 'Base Plates', target: 1200, actual: 1210 },
];

const machineOEEData = [
  { name: 'CNC-01', value: 89 },
  { name: 'ASM-02', value: 78 },
  { name: 'LSR-03', value: 84 },
  { name: 'FLX-04', value: 92 },
];

const COLORS = ['#0F62FE', '#3B82F6', '#10B981', '#F59E0B'];

export const Dashboard: React.FC = () => {
  return (
    <div className="space-y-8">
      {/* Header Panel */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Executive Control Centre</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Live analytics, factory health, and AI operations control.</p>
        </div>

        {/* Global Action Bar */}
        <div className="flex items-center gap-3">
          <div className="relative">
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input 
              type="text" 
              placeholder="Search anything (Cmd+K)" 
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 pl-10 pr-4 py-2 rounded-xl text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-blue-600 w-64 shadow-sm"
            />
          </div>
          <button className="bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold px-4 py-2.5 rounded-xl shadow-md shadow-blue-500/20 transition-all flex items-center gap-2">
            <Sparkles className="w-3.5 h-3.5" />
            AI Reports
          </button>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Card 1 */}
        <motion.div 
          whileHover={{ y: -4 }}
          className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow flex justify-between items-start"
        >
          <div className="space-y-3">
            <span className="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Gross Revenue</span>
            <h3 className="text-2xl font-black text-slate-800 dark:text-white">₹58,45,200</h3>
            <div className="flex items-center gap-1.5 text-emerald-600 dark:text-emerald-400 text-xs font-bold">
              <TrendingUp className="w-3.5 h-3.5" />
              <span>+14.2% vs last month</span>
            </div>
          </div>
          <div className="p-3 bg-blue-50 dark:bg-blue-900/20 rounded-xl text-blue-600 dark:text-blue-400">
            <Activity className="w-5 h-5" />
          </div>
        </motion.div>

        {/* Card 2 */}
        <motion.div 
          whileHover={{ y: -4 }}
          className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow flex justify-between items-start"
        >
          <div className="space-y-3">
            <span className="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Average Plant OEE</span>
            <h3 className="text-2xl font-black text-slate-800 dark:text-white">85.7%</h3>
            <div className="flex items-center gap-1.5 text-emerald-600 dark:text-emerald-400 text-xs font-bold">
              <TrendingUp className="w-3.5 h-3.5" />
              <span>+2.1% from target</span>
            </div>
          </div>
          <div className="p-3 bg-emerald-50 dark:bg-emerald-900/20 rounded-xl text-emerald-600 dark:text-emerald-400">
            <Settings className="w-5 h-5" />
          </div>
        </motion.div>

        {/* Card 3 */}
        <motion.div 
          whileHover={{ y: -4 }}
          className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow flex justify-between items-start"
        >
          <div className="space-y-3">
            <span className="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Work Orders Active</span>
            <h3 className="text-2xl font-black text-slate-800 dark:text-white">12 / 14</h3>
            <div className="flex items-center gap-1.5 text-amber-600 dark:text-amber-400 text-xs font-bold">
              <TrendingDown className="w-3.5 h-3.5" />
              <span>2 backlog delayed</span>
            </div>
          </div>
          <div className="p-3 bg-amber-50 dark:bg-amber-900/20 rounded-xl text-amber-600 dark:text-amber-400">
            <CheckCircle2 className="w-5 h-5" />
          </div>
        </motion.div>

        {/* Card 4 */}
        <motion.div 
          whileHover={{ y: -4 }}
          className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow flex justify-between items-start"
        >
          <div className="space-y-3">
            <span className="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Predictive Shortages</span>
            <h3 className="text-2xl font-black text-slate-800 dark:text-white">3 Items</h3>
            <div className="flex items-center gap-1.5 text-rose-600 dark:text-rose-400 text-xs font-bold">
              <AlertTriangle className="w-3.5 h-3.5" />
              <span>Safety buffer breached</span>
            </div>
          </div>
          <div className="p-3 bg-rose-50 dark:bg-rose-900/20 rounded-xl text-rose-600 dark:text-rose-400">
            <ShieldAlert className="w-5 h-5" />
          </div>
        </motion.div>
      </div>

      {/* AI Operations Insights (Premium Feature) */}
      <div className="bg-gradient-to-r from-blue-600/10 via-indigo-600/5 to-transparent p-6 rounded-2xl border border-blue-200/30 dark:border-blue-900/20 flex flex-col md:flex-row gap-6 items-start">
        <div className="w-12 h-12 rounded-xl bg-blue-600 flex items-center justify-center text-white shrink-0 shadow-lg shadow-blue-500/20">
          <Cpu className="w-6 h-6 animate-pulse" />
        </div>
        <div className="space-y-3 flex-1">
          <div className="flex items-center gap-2">
            <span className="text-xs font-extrabold bg-blue-600/10 text-blue-700 dark:text-blue-400 px-2 py-0.5 rounded-full uppercase tracking-wider">AI Operations Copilot</span>
            <span className="text-xs text-slate-400">Analysed 5 minutes ago</span>
          </div>
          <p className="text-sm font-semibold text-slate-700 dark:text-slate-300 leading-relaxed">
            Overall equipment efficiency is healthy at <strong className="text-blue-600">85.7%</strong>. However, machine <span className="underline decoration-indigo-400 font-bold">MC-CNC-01</span> has reported a <span className="text-amber-600 font-bold">5% increase in core vibration logs</span> over the past 4 hours. A scheduled preventative check is recommended before executing Work Order <strong className="text-slate-800 dark:text-white">#WO-2026-004</strong> to prevent a potential downtime event.
          </p>
          <div className="flex gap-3">
            <button className="text-xs font-bold text-blue-600 hover:text-blue-700 underline">Schedule Inspection</button>
            <button className="text-xs font-bold text-slate-400 hover:text-slate-600 dark:hover:text-slate-200">Dismiss Recommendation</button>
          </div>
        </div>
      </div>

      {/* Chart Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Production chart */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow lg:col-span-2 space-y-4">
          <div className="flex justify-between items-center">
            <div>
              <h4 className="text-sm font-bold text-slate-800 dark:text-white">Revenue vs Cost Run-rate</h4>
              <p className="text-xs text-slate-400">Quarterly financial run rate metrics.</p>
            </div>
            <select className="bg-slate-100 dark:bg-slate-800 text-[10px] font-bold px-2.5 py-1.5 rounded-lg border-0 focus:ring-1 focus:ring-blue-600">
              <option>Last 6 Months</option>
              <option>Last Year</option>
            </select>
          </div>
          <div className="h-72">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={revenueData}>
                <defs>
                  <linearGradient id="colorRev" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#0F62FE" stopOpacity={0.2}/>
                    <stop offset="95%" stopColor="#0F62FE" stopOpacity={0}/>
                  </linearGradient>
                  <linearGradient id="colorCost" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#64748B" stopOpacity={0.2}/>
                    <stop offset="95%" stopColor="#64748B" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" className="dark:stroke-slate-800" />
                <XAxis dataKey="name" fontSize={11} stroke="#94A3B8" />
                <YAxis fontSize={11} stroke="#94A3B8" />
                <Tooltip />
                <Area type="monotone" dataKey="revenue" stroke="#0F62FE" strokeWidth={2.5} fillOpacity={1} fill="url(#colorRev)" name="Revenue" />
                <Area type="monotone" dataKey="cost" stroke="#64748B" strokeWidth={2} fillOpacity={1} fill="url(#colorCost)" name="Operational Cost" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Machine OEE distribution */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow space-y-4">
          <div>
            <h4 className="text-sm font-bold text-slate-800 dark:text-white">Active Machine OEE Distribution</h4>
            <p className="text-xs text-slate-400">Current OEE tracking across workcells.</p>
          </div>
          <div className="h-60 flex justify-center items-center">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={machineOEEData}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={80}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {machineOEEData.map((_, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="grid grid-cols-2 gap-3 text-xs font-semibold text-slate-600 dark:text-slate-400">
            {machineOEEData.map((item, idx) => (
              <div key={item.name} className="flex items-center gap-2">
                <div className="w-2.5 h-2.5 rounded-full" style={{ backgroundColor: COLORS[idx] }} />
                <span>{item.name} ({item.value}%)</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Production Performance and Recent Activity Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Production Target VS Actual */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow space-y-4">
          <div>
            <h4 className="text-sm font-bold text-slate-800 dark:text-white">Production Quantities by Product</h4>
            <p className="text-xs text-slate-400">Target vs actual completed units this shift.</p>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={productionData}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" className="dark:stroke-slate-800" />
                <XAxis dataKey="name" fontSize={11} stroke="#94A3B8" />
                <YAxis fontSize={11} stroke="#94A3B8" />
                <Tooltip />
                <Bar dataKey="target" fill="#94A3B8" radius={[4, 4, 0, 0]} name="Target" />
                <Bar dataKey="actual" fill="#0F62FE" radius={[4, 4, 0, 0]} name="Actual Output" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Live System Log Activity */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 card-shadow space-y-4">
          <div className="flex justify-between items-center">
            <div>
              <h4 className="text-sm font-bold text-slate-800 dark:text-white">Live Plant Audit Trail</h4>
              <p className="text-xs text-slate-400">Real-time system transaction events.</p>
            </div>
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-ping" />
          </div>

          <div className="space-y-4 max-h-64 overflow-y-auto pr-2">
            {[
              { time: '11:02', user: 'Operator Amit', desc: 'Logged downtime event on MC-ASM-02 (material shortage)', type: 'warning' },
              { time: '10:45', user: 'Sales Dept', desc: 'Quotation #Q-9903 approved and converted to Sales Order #SO-2026-004', type: 'success' },
              { time: '10:15', user: 'System AI', desc: 'Recalculated material consumption for Smart Motor V2', type: 'info' },
              { time: '09:30', user: 'Quality Lead', desc: 'Incoming inspection completed for Steel Sheet Batch #20', type: 'success' },
              { time: '08:00', user: 'System', desc: 'Shift B auto-rotation and machine diagnostic checks complete', type: 'info' },
            ].map((act, i) => (
              <div key={i} className="flex gap-3 text-xs">
                <span className="text-slate-400 font-mono shrink-0">{act.time}</span>
                <div className="flex-1">
                  <span className="font-bold text-slate-700 dark:text-slate-300">{act.user}: </span>
                  <span className="text-slate-500 dark:text-slate-400">{act.desc}</span>
                </div>
                <span className={`w-2 h-2 rounded-full shrink-0 mt-1.5 ${
                  act.type === 'success' ? 'bg-emerald-500' :
                  act.type === 'warning' ? 'bg-amber-500' : 'bg-blue-500'
                }`} />
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Sticky Quick-AI Chat Bubble */}
      <div className="fixed bottom-6 right-6 z-40">
        <button className="w-14 h-14 rounded-full bg-blue-600 text-white flex items-center justify-center shadow-2xl hover:scale-105 transition-transform cursor-pointer">
          <MessageSquare className="w-6 h-6" />
        </button>
      </div>
    </div>
  );
};
