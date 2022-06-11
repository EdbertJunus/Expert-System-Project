import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import jess.JessException;
import jess.QueryResult;
import jess.ValueVector;

public class Result extends JFrame {

	JTable physicalTable = new JTable();
	JTable magicTable = new JTable();
	JButton btnClose = new JButton("Close");

	Vector<Vector<Object>> physicalData = new Vector<Vector<Object>>();
	Vector<String> physicalColumns = new Vector<String>();

	Vector<Vector<Object>> magicData = new Vector<Vector<Object>>();
	Vector<String> magicColumns = new Vector<String>();

	JPanel content_panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 30, 30));
	JScrollPane physicalPane = new JScrollPane(physicalTable);
	JScrollPane magicPane = new JScrollPane(magicTable);
	
	String[] physical_column_strings = { "No.", "Name", "Role", "Difficulty", "Price", "PlayRate" };
	String[] magic_column_strings = { "No.", "Name", "Role", "Difficulty", "Price", "MagicPower", "PlayRate" };

	final Result form = this;

	public void initComponents() {
		getContentPane().setLayout(new BorderLayout());

		JPanel left_panel = new JPanel(new GridLayout(0, 3));
		JPanel pLbl = new JPanel();
		JLabel lblInfo = new JLabel("Champion Recommendation");
		pLbl.add(lblInfo);
		
		left_panel.add(new JLabel());
		left_panel.add(lblInfo);
		left_panel.add(new JLabel());

		JLabel lblSkill = new JLabel("High Skill Requirement");
		JLabel lblPlayStyle = new JLabel("Play Style");
		JLabel lblMana = new JLabel("Mana Relient");
		JLabel lblBudget = new JLabel("Budget");
		Object panel_add = null;

		try {
			/* MODIFY Query Result Code Here */
			QueryResult info = Main.rete.runQueryStar("infoQuery",new ValueVector());
			if (info.next()) {

				/* FILL the blanks string with values from your defquery */
				String skill 		= info.getString("skill");
				String playStyle 	= info.getString("playStyle");
				String manaRelient 	= info.getString("manaRelient");
				String budget 		= info.getString("budget");

				left_panel.add(lblSkill);
				left_panel.add(new JLabel(":"));
				left_panel.add(new JLabel(skill));

				left_panel.add(lblPlayStyle);
				left_panel.add(new JLabel(":"));
				left_panel.add(new JLabel(playStyle));

				left_panel.add(lblMana);
				left_panel.add(new JLabel(":"));
				left_panel.add(new JLabel(manaRelient));

				left_panel.add(lblBudget);
				left_panel.add(new JLabel(":"));
				left_panel.add(new JLabel(budget));

				/* MODIFY Query Result Code Here */
				QueryResult champion_result = Main.rete.runQueryStar("championQuery", new ValueVector());

				int physicalCount = 0, magicCount = 0;

				
				for (String s : physical_column_strings) {
					physicalColumns.add(s);
				}
				for (String s : magic_column_strings) {
					magicColumns.add(s);
				}

				while (champion_result.next()) {

					Vector<Object> row = new Vector<Object>();
					String championType = champion_result.getString("Type");
					
					/* FILL the blanks string with values from your defquery */
					String championName 		= "name";
					String championRole 		= "role";
					String championDifficulty 	= "difficulty";
					String championPrice 		= "price";
					String championPlayRate 	= "playRate";
					String championMagicPower 	= "magicPower";

					if (championType.equalsIgnoreCase("magic")) {
						row.add(++magicCount);
						row.add(champion_result.getString(championName));
						row.add(champion_result.getString(championRole));
						row.add(champion_result.getString(championDifficulty));
						row.add(champion_result.getInt(championPrice));
						row.add(champion_result.getInt(championMagicPower));
						row.add(champion_result.getInt(championPlayRate)+"%");
						magicData.add(row);
					} else {
						row.add(++physicalCount);
						row.add(champion_result.getString(championName));
						row.add(champion_result.getString(championRole));
						row.add(champion_result.getString(championDifficulty));
						row.add(champion_result.getInt(championPrice));
						row.add(champion_result.getInt(championPlayRate)+"%");
						physicalData.add(row);
					}

				}

				if (physicalCount + magicCount<= 0) {
					
					JLabel lbl_img = new JLabel();
					lbl_img.setPreferredSize(new Dimension(320, 180));
					Image bufferedImage;
					try {
						bufferedImage = ImageIO.read(getClass().getResource("not_available.png"));
						ImageIcon icon = new ImageIcon(getScaledImage(bufferedImage, 320, 180));
						lbl_img.setIcon(icon);
						panel_add = lbl_img;
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else {

					JPanel panel = new JPanel(new GridLayout(0, 1));
					if (!physicalData.isEmpty()) {

						JPanel mainP = new JPanel(new BorderLayout());

						JPanel p = new JPanel();
						p.add(new JLabel("Physical Champion"));

						mainP.add(p, BorderLayout.NORTH);
						mainP.add(physicalPane, BorderLayout.CENTER);

						panel.add(mainP);
					}
					if (!magicData.isEmpty()) {
						JPanel mainP = new JPanel(new BorderLayout());
						JPanel p = new JPanel();
						p.add(new JLabel("Magic Champion"));

						mainP.add(p, BorderLayout.NORTH);
						mainP.add(magicPane, BorderLayout.CENTER);

						panel.add(mainP);
					}

					physicalPane.setPreferredSize(new Dimension(600, 100));
					physicalTable.setModel(new DefaultTableModel(physicalData, physicalColumns));

					magicPane.setPreferredSize(new Dimension(600, 100));
					magicTable.setModel(new DefaultTableModel(magicData, magicColumns));

					panel_add = panel;
				}

				champion_result.close();
			}
			info.close();
		} catch (JessException e1) {
			e1.printStackTrace();
		}

		content_panel.add(left_panel);
		content_panel.add((Component) panel_add);
		content_panel.setPreferredSize(new Dimension(600, 250));

		getContentPane().add(content_panel, BorderLayout.CENTER);
		getContentPane().add(btnClose, BorderLayout.PAGE_END);

		btnClose.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				form.dispose();
			}
		});
	}

	private Image getScaledImage(Image srcImage, int width, int height) {
		BufferedImage resizedImage = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2d = resizedImage.createGraphics();

		g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
				RenderingHints.VALUE_INTERPOLATION_BICUBIC);
		g2d.drawImage(srcImage, 0, 0, width, height, null);
		g2d.dispose();

		return resizedImage;
	}

	public Result() {
		setTitle("league Of legendS");
		setSize(700, 500);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setResizable(false);

		initComponents();
		setVisible(true);
	}
}