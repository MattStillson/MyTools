using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AcctMgmtWebApp.Models;
using Microsoft.EntityFrameworkCore;

namespace AcctMgmtWebApp.Data
{
    public class EmployeeContext : DbContext
    {
        public EmployeeContext(DbContextOptions<EmployeeContext> options) : base(options)
        {
        }

        public DbSet<ActiveDirectory> ActiveDirectory { get; set; }
        public DbSet<InterActionClient> InterActionClient { get; set; }
        public DbSet<Cvue> Cvue { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ActiveDirectory>().ToTable("ActiveDirectory");
            modelBuilder.Entity<InterActionClient>().ToTable("InterActionClient");
            modelBuilder.Entity<Cvue>().ToTable("Cvue");
        }
    }
}
