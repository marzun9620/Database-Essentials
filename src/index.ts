import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

interface CompanyStats {
  company_name: string;
  slug: string;
  user_count: string;
}

async function main(): Promise<void> {
  console.log("🔍 Testing Dual Database Strategy (Prisma ORM + Typed SQL)...");

  try {
    // Test basic connection
    await prisma.$connect();
    console.log("✅ Prisma connected successfully!");

    // Test Prisma ORM operations (simple CRUD)
    console.log("\n📊 Testing Prisma ORM operations...");

    // Get companies using Prisma ORM
    const companies = await prisma.company.findMany({
      include: {
        users: {
          include: {
            user_role: true,
          },
        },
      },
    });

    console.log(`📈 Found ${companies.length} companies`);

    companies.forEach((company) => {
      const userCount = company.users?.length ?? 0;
      console.log(
        `🏢 ${company.name} (${company.slug}) - ${userCount} users`
      );
    });

    // Test Typed SQL operations (complex queries)
    console.log("\n🔧 Testing Typed SQL operations...");

    if (companies.length > 0) {
      const firstCompany = companies[0];
      if (firstCompany) {
        const firstCompanyId = firstCompany.id;

        // Import typed SQL functions (these will be generated)
        // Note: In a real setup, these would be auto-generated from prisma/sql/*.sql files
        console.log(`📋 Testing queries for company: ${firstCompany.name}`);

        // Example of how you would use typed SQL (commented out since we need to generate first)
        /*
        import { getCompanyWithUserCount, getUsersByCompany } from "@prisma/client/sql";
        
        const companyStats = await prisma.$queryRawTyped(
          getCompanyWithUserCount(firstCompanyId)
        );
        
        const usersWithRoles = await prisma.$queryRawTyped(
          getUsersByCompany(firstCompanyId)
        );
        */

        // For now, let's test with a simple raw query
        const companyStats = await prisma.$queryRaw<CompanyStats[]>`
          SELECT 
            c.name as company_name,
            c.slug,
            COUNT(u.id) as user_count
          FROM practice_app.company c
          LEFT JOIN practice_app.users u ON c.id = u.company_id
          WHERE c.id = ${firstCompanyId}::uuid
          GROUP BY c.id, c.name, c.slug
        `;

        console.log("📊 Company Stats:", companyStats);
      }
    }

    console.log("\n🎉 Dual Database Strategy test completed!");
    console.log("\n📝 Next steps:");
    console.log(
      "1. Run: npm run prisma:pull:gen (to generate Prisma schema from DB)"
    );
    console.log(
      "2. Run: npm run sql:generate (to generate typed SQL functions)"
    );
    console.log("3. Use typed SQL functions in your code");
  } catch (error) {
    console.error("❌ Test failed:", error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
