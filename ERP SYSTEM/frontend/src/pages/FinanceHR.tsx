import React, { useState } from 'react';
import { 
  DollarSign, 
  TrendingUp, 
  TrendingDown, 
  Users, 
  Check, 
  X, 
  Download
} from 'lucide-react';

interface JournalEntry {
  id: string;
  code: string;
  account: string;
  amount: number;
  type: 'Income' | 'Expense';
  date: string;
  desc: string;
}

interface Employee {
  id: string;
  name: string;
  position: string;
  shift: string;
  status: 'Present' | 'Absent' | 'On Leave';
  avatar: string;
}

interface LeaveRequest {
  id: string;
  name: string;
  position: string;
  reason: string;
  dates: string;
  days: number;
}

export const FinanceHR: React.FC = () => {
  const [activeSubTab, setActiveSubTab] = useState<'finance' | 'hr'>('finance');

  // Mock Finance Data
  const [ledger] = useState<JournalEntry[]>([
    { id: '1', code: 'TR-90021', account: 'Sales Revenue', amount: 1245000, type: 'Income', date: '2026-07-06', desc: 'Motor Batch #82 dispatch revenue' },
    { id: '2', code: 'TR-90022', account: 'Steel Supplier Inc', amount: 450000, type: 'Expense', date: '2026-07-05', desc: 'Bulk steel raw materials purchase' },
    { id: '3', code: 'TR-90023', account: 'Electricity Utility', amount: 189000, type: 'Expense', date: '2026-07-04', desc: 'Shop floor power bill' },
    { id: '4', code: 'TR-90024', account: 'Sales Revenue', amount: 980000, type: 'Income', date: '2026-07-03', desc: 'Robotic Grip Assembly contract deposit' },
    { id: '5', code: 'TR-90025', account: 'Taxes & GST Payable', amount: 220000, type: 'Expense', date: '2026-07-02', desc: 'Q2 local manufacturing tax payment' },
  ]);

  // Mock HR Data
  const [employees, setEmployees] = useState<Employee[]>([
    { id: '1', name: 'Rajesh Kumar', position: 'CNC Machinist Lead', shift: 'Shift A', status: 'Present', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80' },
    { id: '2', name: 'Amit Sharma', position: 'Assembly Operator', shift: 'Shift A', status: 'Present', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80' },
    { id: '3', name: 'Pooja Patel', position: 'Molding Technician', shift: 'Shift B', status: 'Present', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80' },
    { id: '4', name: 'Vikram Singh', position: 'Laser CNC Operator', shift: 'Shift A', status: 'Absent', avatar: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=100&q=80' },
    { id: '5', name: 'Nikhil Sen', position: 'Quality Inspector', shift: 'Shift C', status: 'On Leave', avatar: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=100&q=80' },
  ]);

  const [leaveRequests, setLeaveRequests] = useState<LeaveRequest[]>([
    { id: '1', name: 'Vikram Singh', position: 'Laser CNC Operator', reason: 'Medical Checkup', dates: '2026-07-07 to 2026-07-08', days: 2 },
    { id: '2', name: 'Nikhil Sen', position: 'Quality Inspector', reason: 'Family event', dates: '2026-07-12 to 2026-07-15', days: 3 }
  ]);

  const handleApproveLeave = (id: string, employeeName: string) => {
    // remove from list
    setLeaveRequests(prev => prev.filter(r => r.id !== id));
    // update employee status
    setEmployees(prev => prev.map(emp => {
      if (emp.name === employeeName) {
        return { ...emp, status: 'On Leave' };
      }
      return emp;
    }));
  };

  const handleRejectLeave = (id: string) => {
    setLeaveRequests(prev => prev.filter(r => r.id !== id));
  };

  // Calculated P&L
  const totalIncome = ledger.filter(l => l.type === 'Income').reduce((acc, c) => acc + c.amount, 0);
  const totalExpenses = ledger.filter(l => l.type === 'Expense').reduce((acc, c) => acc + c.amount, 0);
  const netProfit = totalIncome - totalExpenses;
  const profitMargin = ((netProfit / totalIncome) * 100).toFixed(1);

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Finance & HR Core</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">General ledger auditing, cash flow analysis, shift rosters, and payroll leave gates.</p>
        </div>

        {/* Subtab Toggle Buttons */}
        <div className="flex bg-slate-100 dark:bg-slate-800 p-1.5 rounded-xl border border-slate-200/50 dark:border-slate-800/80">
          <button 
            onClick={() => setActiveSubTab('finance')}
            className={`px-4 py-2 text-xs font-bold rounded-lg transition-all ${
              activeSubTab === 'finance' 
                ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-white shadow-sm' 
                : 'text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
            }`}
          >
            General Ledger & Accounts
          </button>
          <button 
            onClick={() => setActiveSubTab('hr')}
            className={`px-4 py-2 text-xs font-bold rounded-lg transition-all ${
              activeSubTab === 'hr' 
                ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-white shadow-sm' 
                : 'text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
            }`}
          >
            HR & Shift Roster
          </button>
        </div>
      </div>

      {activeSubTab === 'finance' ? (
        <div className="space-y-8">
          {/* Profit & Loss Grid */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
              <div className="p-3 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 rounded-xl">
                <TrendingUp className="w-6 h-6" />
              </div>
              <div>
                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Total Monthly Revenues</span>
                <span className="text-xl font-black text-slate-800 dark:text-white">₹{(totalIncome / 100000).toFixed(2)} Lakh</span>
              </div>
            </div>

            <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
              <div className="p-3 bg-rose-50 dark:bg-rose-900/20 text-rose-600 dark:text-rose-400 rounded-xl">
                <TrendingDown className="w-6 h-6" />
              </div>
              <div>
                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Operating Expenses (OPEX)</span>
                <span className="text-xl font-black text-slate-800 dark:text-white">₹{(totalExpenses / 100000).toFixed(2)} Lakh</span>
              </div>
            </div>

            <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
              <div className="p-3 bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 rounded-xl">
                <DollarSign className="w-6 h-6" />
              </div>
              <div>
                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Net Income Margin</span>
                <span className="text-xl font-black text-slate-800 dark:text-white">₹{(netProfit / 100000).toFixed(2)} L ({profitMargin}%)</span>
              </div>
            </div>
          </div>

          {/* Accounts General Ledger Table */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <h3 className="font-bold text-slate-800 dark:text-white text-base">General Ledger Accounts</h3>
                <p className="text-xs text-slate-400">Audited journal entry transactions for plant operations.</p>
              </div>

              <button className="p-2 border border-slate-200 dark:border-slate-800 rounded-lg text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800 flex items-center gap-1.5 text-xs font-semibold">
                <Download className="w-4 h-4" />
                Export Ledger
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs whitespace-nowrap">
                <thead>
                  <tr className="border-b border-slate-200 dark:border-slate-800 text-slate-400 font-extrabold uppercase tracking-wider">
                    <th className="py-3">Transaction ID</th>
                    <th className="py-3">Account Head</th>
                    <th className="py-3">Type</th>
                    <th className="py-3">Description</th>
                    <th className="py-3 text-right">Debit / Credit Amount</th>
                    <th className="py-3">Posting Date</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80">
                  {ledger.map((item) => (
                    <tr key={item.id} className="text-slate-600 dark:text-slate-400 font-medium">
                      <td className="py-3.5 font-mono font-bold text-slate-800 dark:text-white">{item.code}</td>
                      <td className="py-3.5 font-semibold text-slate-800 dark:text-slate-300">{item.account}</td>
                      <td className="py-3.5">
                        <span className={`px-2 py-0.5 rounded-full text-[9px] font-bold border ${
                          item.type === 'Income' 
                            ? 'bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 dark:text-emerald-400 border-emerald-200/50' 
                            : 'bg-rose-50 dark:bg-rose-950/20 text-rose-600 dark:text-rose-400 border-rose-200/50'
                        }`}>
                          {item.type}
                        </span>
                      </td>
                      <td className="py-3.5 max-w-xs truncate">{item.desc}</td>
                      <td className={`py-3.5 text-right font-bold ${item.type === 'Income' ? 'text-emerald-600' : 'text-slate-800 dark:text-white'}`}>
                        {item.type === 'Income' ? '+' : '-'}₹{item.amount.toLocaleString()}
                      </td>
                      <td className="py-3.5 text-slate-400 font-semibold">{item.date}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Roster list */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 lg:col-span-2 space-y-4">
            <h3 className="font-bold text-slate-800 dark:text-white text-base">Active Shift Roster Directory</h3>
            
            <div className="space-y-4">
              {employees.map(emp => {
                const statusStyles = {
                  Present: 'bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 dark:text-emerald-400 border-emerald-200/50',
                  Absent: 'bg-rose-50 dark:bg-rose-950/20 text-rose-600 dark:text-rose-400 border-rose-200/50',
                  'On Leave': 'bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 border-slate-200/50',
                };

                return (
                  <div key={emp.id} className="flex justify-between items-center p-3 rounded-xl border border-slate-100 dark:border-slate-800/60 hover:bg-slate-50/50 dark:hover:bg-slate-800/20 transition-all">
                    <div className="flex items-center gap-3">
                      <img src={emp.avatar} alt={emp.name} className="w-10 h-10 rounded-full object-cover" />
                      <div>
                        <h4 className="text-xs font-bold text-slate-800 dark:text-white">{emp.name}</h4>
                        <p className="text-[10px] text-slate-400 font-semibold mt-0.5">{emp.position}</p>
                      </div>
                    </div>

                    <div className="flex items-center gap-6 text-xs font-semibold">
                      <span className="text-slate-500 dark:text-slate-400">{emp.shift}</span>
                      <span className={`px-2 py-0.5 border rounded-full text-[9px] font-bold ${statusStyles[emp.status]}`}>
                        {emp.status}
                      </span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Leave approvals */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 flex flex-col justify-between">
            <div className="space-y-4">
              <h3 className="font-bold text-slate-800 dark:text-white text-base">Pending Leave Approvals</h3>
              <p className="text-xs text-slate-400">Shift operator absences require supervisor validation.</p>
            </div>

            {leaveRequests.length > 0 ? (
              <div className="space-y-4 py-4 flex-1 overflow-y-auto">
                {leaveRequests.map(r => (
                  <div key={r.id} className="bg-slate-50 dark:bg-slate-800/40 p-4 rounded-xl border border-slate-100 dark:border-slate-800 space-y-3">
                    <div className="flex justify-between items-start">
                      <div>
                        <h4 className="text-xs font-bold text-slate-800 dark:text-white">{r.name}</h4>
                        <p className="text-[9px] text-slate-400 font-bold mt-0.5">{r.position}</p>
                      </div>
                      <span className="text-[10px] font-bold bg-amber-50 dark:bg-amber-950/20 text-amber-600 dark:text-amber-400 px-1.5 py-0.5 rounded">
                        {r.days} Days
                      </span>
                    </div>
                    
                    <p className="text-[10px] text-slate-600 dark:text-slate-400 italic">"{r.reason}"</p>
                    <p className="text-[9px] text-slate-400 font-bold">{r.dates}</p>

                    <div className="flex gap-2 pt-1.5">
                      <button 
                        onClick={() => handleRejectLeave(r.id)}
                        className="flex-1 py-1.5 rounded-lg border border-slate-200 dark:border-slate-700 text-[10px] font-bold text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/20 transition-all flex items-center justify-center gap-1"
                      >
                        <X className="w-3.5 h-3.5" />
                        Reject
                      </button>
                      <button 
                        onClick={() => handleApproveLeave(r.id, r.name)}
                        className="flex-1 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-[10px] font-bold text-white shadow-sm transition-all flex items-center justify-center gap-1"
                      >
                        <Check className="w-3.5 h-3.5" />
                        Approve
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="border border-dashed border-slate-200 dark:border-slate-800 rounded-2xl flex-1 flex flex-col items-center justify-center p-6 text-center text-slate-400 my-4">
                <Users className="w-12 h-12 text-slate-300 mb-3" />
                <p className="text-xs font-bold">All caught up!</p>
                <p className="text-[10px] mt-1 text-slate-400">There are no pending employee leave requests requiring validation.</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
