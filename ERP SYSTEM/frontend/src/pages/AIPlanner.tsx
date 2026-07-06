import React, { useState } from 'react';
import { 
  Cpu, 
  Sparkles, 
  Zap, 
  Mic, 
  Send, 
  CheckCircle2, 
  RefreshCw, 
  MessageSquare,
  Package,
  Wrench
} from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

interface ForecastData {
  day: string;
  historicalSales: number;
  predictedSales: number;
}

export const AIPlanner: React.FC = () => {
  const [isOptimizing, setIsOptimizing] = useState(false);
  const [optimizationLog, setOptimizationLog] = useState<string[]>([]);
  const [isOptimized, setIsOptimized] = useState(false);
  const [chatMessages, setChatMessages] = useState<{ sender: 'user' | 'ai'; text: string }[]>([
    { sender: 'ai', text: "Hello! I am Apex AI. I have analysed your shop floor. Ask me to 'Optimize Shift A scheduling' or 'Check inventory buffers'." }
  ]);
  const [chatInput, setChatInput] = useState('');

  // Forecast data (historical vs predicted)
  const salesForecastData: ForecastData[] = [
    { day: 'Mon', historicalSales: 45, predictedSales: 45 },
    { day: 'Tue', historicalSales: 48, predictedSales: 48 },
    { day: 'Wed', historicalSales: 52, predictedSales: 52 },
    { day: 'Thu', historicalSales: 50, predictedSales: 50 },
    { day: 'Fri', historicalSales: 0, predictedSales: 68 }, // predicted boost
    { day: 'Sat', historicalSales: 0, predictedSales: 75 },
    { day: 'Sun', historicalSales: 0, predictedSales: 80 },
  ];

  const handleRunOptimization = () => {
    setIsOptimizing(true);
    setOptimizationLog([]);
    setIsOptimized(false);

    const logSteps = [
      "Connecting to shop floor telemetry and machine registers...",
      "Reading Active Sales Orders pipeline: SO-2026-004 and SO-2026-005...",
      "Simulating machine loading constraints for MC-CNC-01 and MC-ASM-02...",
      "Detecting tool wear indicators on laser cutter MC-LSR-03...",
      "Rescheduling Work Order WO-2026-002 forward to maximize OEE by 4.2%...",
      "Resolving raw material shortages by routing extra steel from Warehouse C..."
    ];

    logSteps.forEach((step, index) => {
      setTimeout(() => {
        setOptimizationLog(prev => [...prev, step]);
        if (index === logSteps.length - 1) {
          setIsOptimizing(false);
          setIsOptimized(true);
        }
      }, (index + 1) * 800);
    });
  };

  const handleSendChat = () => {
    if (!chatInput.trim()) return;
    const userMsg = chatInput;
    setChatMessages(prev => [...prev, { sender: 'user', text: userMsg }]);
    setChatInput('');

    setTimeout(() => {
      let aiText = "I have processed your query. Let me know if you would like me to adjust stock or schedule work cells.";
      if (userMsg.toLowerCase().includes('optimize') || userMsg.toLowerCase().includes('schedule')) {
        aiText = "Based on machine OEE logs and tool wear, I suggest moving Work Order #WO-2026-002 to machine MC-ASM-02. This will reduce scheduled downtime by 24 minutes. Would you like me to push this to the database?";
      } else if (userMsg.toLowerCase().includes('shortage') || userMsg.toLowerCase().includes('inventory')) {
        aiText = "Copper Winding Wire (RM-COIL-012) is below safety buffer (150/200 kg). I recommend ordering 100 kg from Vendor 'Copper Tech Corp' to satisfy upcoming Work Orders. Click 'Auto-Order' to execute.";
      }
      setChatMessages(prev => [...prev, { sender: 'ai', text: aiText }]);
    }, 1000);
  };

  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">AI Core Planner</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Harness advanced machine learning for sales forecasting, shop floor optimizations, and voice assistant operations.</p>
        </div>
      </div>

      {/* Sales Forecast Graph and AI Actions */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Forecast Area Chart */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 lg:col-span-2 space-y-4">
          <div>
            <h3 className="font-bold text-slate-800 dark:text-white text-base">Predictive Sales Demand Forecast</h3>
            <p className="text-xs text-slate-400">Comparing active actual sales orders with AI-predicted market demand.</p>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={salesForecastData}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" className="dark:stroke-slate-800" />
                <XAxis dataKey="day" fontSize={11} stroke="#94A3B8" />
                <YAxis fontSize={11} stroke="#94A3B8" />
                <Tooltip />
                <Area type="monotone" dataKey="historicalSales" stroke="#94A3B8" strokeWidth={2} fillOpacity={0.05} fill="#94A3B8" name="Historical Orders" />
                <Area type="monotone" dataKey="predictedSales" stroke="#2563EB" strokeWidth={2.5} fillOpacity={0.1} fill="#2563EB" name="AI Predicted Demand" strokeDasharray="5 5" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* AI Recommendations panel */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 flex flex-col justify-between">
          <div className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600">
              <Sparkles className="w-5 h-5" />
              <h3 className="font-bold text-slate-800 dark:text-white text-sm uppercase tracking-wider">AI Priority Triggers</h3>
            </div>
            
            <div className="space-y-3.5 flex-1 overflow-y-auto">
              <div className="p-3 bg-rose-50/50 dark:bg-rose-950/20 border border-rose-100 dark:border-rose-900/30 rounded-xl space-y-2 text-xs">
                <div className="flex items-center gap-2 text-rose-700 dark:text-rose-400 font-bold">
                  <Package className="w-4 h-4" />
                  <span>Depletion Forecast Alert</span>
                </div>
                <p className="text-slate-600 dark:text-slate-400 font-medium">Copper Winding Wire (RM-COIL-012) is forecast to deplete fully on July 11.</p>
                <button className="text-[10px] font-extrabold text-blue-600 hover:text-blue-700 underline">Generate PO Recommendations</button>
              </div>

              <div className="p-3 bg-amber-50/50 dark:bg-amber-950/20 border border-amber-100 dark:border-amber-900/30 rounded-xl space-y-2 text-xs">
                <div className="flex items-center gap-2 text-amber-700 dark:text-amber-400 font-bold">
                  <Wrench className="w-4 h-4" />
                  <span>Predictive Maintenance Warning</span>
                </div>
                <p className="text-slate-600 dark:text-slate-400 font-medium">MC-LSR-03 shows rising thermal log signatures; schedule cleaning before July 9.</p>
                <button className="text-[10px] font-extrabold text-blue-600 hover:text-blue-700 underline">Add Maintenance Schedule</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Interactive AI Production Scheduler and Chat Console */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Scheduler Simulator */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 space-y-6 flex flex-col justify-between">
          <div className="space-y-1.5">
            <h3 className="font-bold text-slate-800 dark:text-white text-base flex items-center gap-2">
              <Zap className="w-5 h-5 text-blue-600" />
              AI Production Scheduling Optimizer
            </h3>
            <p className="text-xs text-slate-400">Re-sequences the pending and active work orders dynamically to reduce changeover latency and maximize plant efficiency.</p>
          </div>

          {/* Optimizer console logger */}
          <div className="h-44 bg-slate-950 text-slate-300 font-mono text-[10px] p-4 rounded-xl overflow-y-auto space-y-2 flex flex-col justify-end">
            {optimizationLog.map((log, idx) => (
              <div key={idx} className="flex gap-2 items-start animate-fade-in">
                <span className="text-blue-500 font-bold">✔</span>
                <span>{log}</span>
              </div>
            ))}
            {isOptimizing && (
              <div className="flex items-center gap-2 text-blue-400">
                <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                <span>Running genetic scheduling heuristic...</span>
              </div>
            )}
            {!isOptimizing && optimizationLog.length === 0 && (
              <div className="text-slate-500 italic text-center py-10">
                Click 'Run AI Optimization Engine' to begin re-sequencing pipeline.
              </div>
            )}
          </div>

          <div className="flex items-center justify-between gap-4 pt-2">
            <div className="text-xs">
              {isOptimized && (
                <span className="flex items-center gap-1.5 text-emerald-600 font-bold">
                  <CheckCircle2 className="w-4 h-4" />
                  Scheduled Optimized (+4.2% OEE)
                </span>
              )}
            </div>
            
            <button 
              onClick={handleRunOptimization}
              disabled={isOptimizing}
              className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-800/50 text-white text-xs font-bold px-4 py-2.5 rounded-xl shadow-md shadow-blue-500/20 transition-all flex items-center gap-2 shrink-0 cursor-pointer"
            >
              {isOptimizing ? <RefreshCw className="w-3.5 h-3.5 animate-spin" /> : <Cpu className="w-3.5 h-3.5" />}
              Run AI Optimization Engine
            </button>
          </div>
        </div>

        {/* Chatbot Console */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 flex flex-col justify-between h-[380px]">
          <div className="flex justify-between items-center border-b border-slate-100 dark:border-slate-800 pb-3">
            <div className="flex items-center gap-2">
              <MessageSquare className="w-5 h-5 text-blue-600" />
              <h3 className="font-bold text-slate-800 dark:text-white text-sm">Natural Language Operations Copilot</h3>
            </div>
            <span className="w-2 h-2 rounded-full bg-blue-500 animate-pulse" />
          </div>

          {/* Chat message history */}
          <div className="flex-1 overflow-y-auto py-4 space-y-3 pr-1 text-xs">
            {chatMessages.map((msg, i) => (
              <div key={i} className={`flex ${msg.sender === 'user' ? 'justify-end' : 'justify-start'}`}>
                <div className={`max-w-[80%] rounded-2xl px-4 py-2.5 ${
                  msg.sender === 'user' 
                    ? 'bg-blue-600 text-white rounded-br-none' 
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 rounded-bl-none'
                }`}>
                  <p className="font-medium">{msg.text}</p>
                </div>
              </div>
            ))}
          </div>

          {/* Chat input box */}
          <div className="flex items-center gap-2 border-t border-slate-100 dark:border-slate-800 pt-3">
            <button className="p-2.5 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl text-slate-400 hover:text-slate-600 transition-colors">
              <Mic className="w-4 h-4" />
            </button>
            <input 
              type="text" 
              placeholder="Ask AI to scheduling or check stock..." 
              value={chatInput}
              onChange={(e) => setChatInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSendChat()}
              className="flex-1 bg-slate-50 dark:bg-slate-900 pl-4 pr-2 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 text-xs focus:outline-none focus:ring-1 focus:ring-blue-600"
            />
            <button 
              onClick={handleSendChat}
              className="p-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl shadow-md shadow-blue-500/10 cursor-pointer"
            >
              <Send className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
